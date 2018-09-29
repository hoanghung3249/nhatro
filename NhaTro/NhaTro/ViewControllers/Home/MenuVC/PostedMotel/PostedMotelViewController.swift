//
//  PostedMotelViewController.swift
//  NhaTro
//
//  Created by HOANGHUNG on 2/21/18.
//  Copyright © 2018 HOANG HUNG. All rights reserved.
//

import UIKit
import KRPullLoader
import HGPlaceholders

class PostedMotelViewController: UIViewController {
    
    // MARK: - Outlets and Variables
    @IBOutlet weak var cvwMotel: CollectionView!
    
    fileprivate var placeholderCollectionView: CollectionView? {
        get { return cvwMotel }
    }
    fileprivate var arrMotel = [Motel]()
    private let loadMoreView = KRPullLoadView()
    private let refreshView = KRPullLoadView()
    fileprivate var current_Page:Int = 1
    fileprivate var total_pages:Int = 0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getListMotel(current_Page)
        arrMotel.removeAll()
        self.setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cvwMotel.removePullLoadableView(loadMoreView)
        cvwMotel.removePullLoadableView(refreshView)
    }
    
    //MARK:- Support functions
    private func setupLayout() {
        navigationItem.title = "Phòng Trọ"
    }
    
    private func setupCollectionView() {
        cvwMotel.delegate = self
        cvwMotel.dataSource = self
        //Setup layout for item in collectionview
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: 181)
        layout.scrollDirection = .vertical
        cvwMotel.collectionViewLayout = layout
        
        //Register cell for collectionView
        let nib = UINib(nibName: "HomePageCell", bundle: nil)
        cvwMotel.register(nib, forCellWithReuseIdentifier: "HomePageCollectionViewCell")
        loadMoreView.delegate = self
        refreshView.delegate = self
        cvwMotel.addPullLoadableView(loadMoreView, type: .loadMore)
        cvwMotel.addPullLoadableView(refreshView, type: .refresh)
        setupPlaceholder()
    }
    
    private func setupPlaceholder() {
        placeholderCollectionView?.placeholderDelegate = self
        placeholderCollectionView?.placeholdersProvider = .nhatroProvider
        placeholderCollectionView?.showLoadingPlaceholder()
    }
}

// MARK: - API Helper
extension PostedMotelViewController {
    
    private func getListMotel(_ currentPage: Int) {
        ProgressView.shared.show(view)
        DataCenter.shared.getListUserMotel(page: currentPage) { [weak self] (success, mess, arrMotel, paging) in
            guard let strongSelf = self else { return }
            ProgressView.shared.hide()
            if success {
                guard let paging = paging else { return }
                strongSelf.total_pages = paging.total_pages
                for motel in arrMotel {
                    strongSelf.arrMotel.append(motel)
                }
                DispatchQueue.main.async {
                    strongSelf.cvwMotel.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    strongSelf.cvwMotel.reloadData()
                    strongSelf.placeholderCollectionView?.showErrorPlaceholder()
                }
            }
        }
    }
    
}

// MARK: - CollectionView DataSource and Delegate
extension PostedMotelViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
extension PostedMotelViewController: KRPullLoadViewDelegate {
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
extension PostedMotelViewController: PlaceholderDelegate {
    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        (view as? CollectionView)?.showDefault()
        refreshPage()
    }
}