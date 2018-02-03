//
//  HomePageViewController.swift
//  NhaTro
//
//  Created by DUY on 9/15/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
import KRPullLoader
import HGPlaceholders

class HomePageViewController: UIViewController {

//    @IBOutlet weak var cvwDetails: UICollectionView!
    
    @IBOutlet weak var cvwDetails: CollectionView!
    fileprivate var arrMotel = [Motel]()
    fileprivate var current_Page:Int = 1
    fileprivate var total_pages:Int = 0
    
    private let loadMoreView = KRPullLoadView()
    private let refreshView = KRPullLoadView()
    fileprivate var placeholderCollectionView: CollectionView? {
        get { return cvwDetails }
    }
    fileprivate let handleNetwork = HandleNetwork()
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.setup()
        getListMotel(current_Page)
        arrMotel.removeAll()
        self.setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
        reachabilityChanged()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cvwDetails.removePullLoadableView(loadMoreView)
        cvwDetails.removePullLoadableView(refreshView)
        handleNetwork.stopNotifier()
    }
    
    //MARK:- Support functions
    private func setupLayout() {
        navigationItem.title = "Trang Chủ"
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupCollectionView() {
        cvwDetails.delegate = self
        cvwDetails.dataSource = self
        //Setup layout for item in collectionview
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: 181)
        layout.scrollDirection = .vertical
        cvwDetails.collectionViewLayout = layout
        
        //Register cell for collectionView
        let nib = UINib(nibName: "HomePageCell", bundle: nil)
        cvwDetails.register(nib, forCellWithReuseIdentifier: "HomePageCollectionViewCell")
        loadMoreView.delegate = self
        refreshView.delegate = self
        cvwDetails.addPullLoadableView(loadMoreView, type: .loadMore)
        cvwDetails.addPullLoadableView(refreshView, type: .refresh)
        setupPlaceholder()
    }
    
    private func setupPlaceholder() {
        placeholderCollectionView?.placeholderDelegate = self
        placeholderCollectionView?.placeholdersProvider = .nhatroProvider
        placeholderCollectionView?.showLoadingPlaceholder()
    }
    
    fileprivate func getListMotel(_ page:Int) {
        ProgressView.shared.show(view)
        DataCenter.shared.callAPIGetListMotel(page: page) { [weak self] (success, mess, arrMotel, paging) in
            guard let strongSelf = self else { return }
            ProgressView.shared.hide()
            if success {
                guard let paging = paging else { return }
                strongSelf.total_pages = paging.total_pages
                for motel in arrMotel {
                    strongSelf.arrMotel.append(motel)
                }
                DispatchQueue.main.async {
                    strongSelf.cvwDetails.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    strongSelf.cvwDetails.reloadData()
                    strongSelf.placeholderCollectionView?.showErrorPlaceholder()
                }
            }
        }
    }
    
    fileprivate func reachabilityChanged() {
        handleNetwork.networkChange = { (hasConnection) in
            if hasConnection {
                print("has connection")
            } else {
                print("lost connection")
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Action buttons
    @IBAction func showMap(_ sender: UIButton) {
        let mapVC = Storyboard.home.instantiateViewController(ofType: MapViewController.self)
        self.navigationItem.title = ""
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
}

//MARK:- CollectionView Datasource & Delegate
extension HomePageViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMotel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ofType: HomePageCollectionViewCell.self, at: indexPath)
        if arrMotel.count > 0 {
            let motel = arrMotel[indexPath.row]
            cell.configHomeCell(motel)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 181)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let motel = arrMotel[indexPath.row]
        let detailVC = Storyboard.detail.instantiateViewController(ofType: DetailHostelViewController.self)
        detailVC.motel = motel
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - KRPullLoader Delegate
extension HomePageViewController: KRPullLoadViewDelegate {
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        weak var `self` = self
        if type == .loadMore {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    guard let strongSelf = self else { return }
                    completionHandler()
                    strongSelf.loadMore()
                }
            default: break
            }
        } else {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    guard let strongSelf = self else { return }
                    completionHandler()
                    strongSelf.refreshPage()
                })
            default: break
            }
        }
    }
    
    private func loadMore() {
        if current_Page < total_pages {
            current_Page += 1
            getListMotel(current_Page)
        }
    }
    
    fileprivate func refreshPage() {
        current_Page = 1
        arrMotel.removeAll()
        getListMotel(current_Page)
    }
}

// MARK: - Placeholder delegate
extension HomePageViewController: PlaceholderDelegate {
    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        (view as? CollectionView)?.showDefault()
        refreshPage()
    }
}
