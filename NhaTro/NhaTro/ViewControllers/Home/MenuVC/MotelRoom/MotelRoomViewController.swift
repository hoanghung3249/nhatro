//
//  MotelRoomViewController.swift
//  NhaTro
//
//  Created by HOANGHUNG on 2/21/18.
//  Copyright © 2018 HOANG HUNG. All rights reserved.
//

import UIKit
import HGPlaceholders
import KRPullLoader

class MotelRoomViewController: UIViewController {
    
    // MARK: - Outlets and Variables
    @IBOutlet weak var cvwMotelRoom: CollectionView!
    
    fileprivate var placeholderCollectionView: CollectionView? {
        get { return cvwMotelRoom }
    }
    fileprivate var arrMotel = [MotelRoom]()
    private let loadMoreView = KRPullLoadView()
    private let refreshView = KRPullLoadView()
    fileprivate var current_Page:Int = 1
    fileprivate var total_pages:Int = 0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        callAPIGetListMotelRoom(current_Page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cvwMotelRoom.removePullLoadableView(loadMoreView)
        cvwMotelRoom.removePullLoadableView(refreshView)
    }

    //MARK:- Support functions
    private func setupLayout() {
        navigationItem.title = "Phòng Trọ"
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupCollectionView() {
        cvwMotelRoom.delegate = self
        cvwMotelRoom.dataSource = self
        //Setup layout for item in collectionview
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: 181)
        layout.scrollDirection = .vertical
        cvwMotelRoom.collectionViewLayout = layout
        
        //Register cell for collectionView
        let nib = UINib(nibName: "HomePageCell", bundle: nil)
        cvwMotelRoom.register(nib, forCellWithReuseIdentifier: "HomePageCollectionViewCell")
        loadMoreView.delegate = self
        refreshView.delegate = self
        cvwMotelRoom.addPullLoadableView(loadMoreView, type: .loadMore)
        cvwMotelRoom.addPullLoadableView(refreshView, type: .refresh)
        setupPlaceholder()
    }
    
    private func setupPlaceholder() {
        placeholderCollectionView?.placeholderDelegate = self
        placeholderCollectionView?.placeholdersProvider = .nhatroProvider
        placeholderCollectionView?.showLoadingPlaceholder()
    }
    
}

// MARK: - API Helper
extension MotelRoomViewController {
    
    private func callAPIGetListMotelRoom(_ currentPage: Int) {
        ProgressView.shared.show(view)
        DataCenter.shared.getListRoomMotel(page: currentPage) { [weak self] (isSuccess, mess, arrRoom, paging) in
            ProgressView.shared.hide()
            guard let strongSelf = self else { return }
            if isSuccess {
                guard let paging = paging else { return }
                strongSelf.total_pages = paging.total_pages
                for motel in arrRoom {
                    strongSelf.arrMotel.append(motel)
                }
                DispatchQueue.main.async {
                    strongSelf.cvwMotelRoom.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    strongSelf.cvwMotelRoom.reloadData()
                    strongSelf.placeholderCollectionView?.showErrorPlaceholder()
                }
            }
        }
    }
    
}

// MARK: - CollectionView DataSource and Delegate
extension MotelRoomViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMotel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ofType: HomePageCollectionViewCell.self, at: indexPath)
        if arrMotel.count > 0 {
//            let motel = arrMotel[indexPath.row]
//            cell.configHomeCell(motel)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 181)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let motel = arrMotel[indexPath.row]
//        let detailVC = Storyboard.detail.instantiateViewController(ofType: DetailHostelViewController.self)
//        detailVC.motel = motel
//        DispatchQueue.main.async { [weak self] in
//            guard let strongSelf = self else { return }
//            strongSelf.navigationController?.pushViewController(detailVC, animated: true)
//        }
    }
}

// MARK: - KRPullLoader Delegate
extension MotelRoomViewController: KRPullLoadViewDelegate {
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
            callAPIGetListMotelRoom(current_Page)
        }
    }
    
    fileprivate func refreshPage() {
        current_Page = 1
        arrMotel.removeAll()
        callAPIGetListMotelRoom(current_Page)
    }
}

// MARK: - Placeholder delegate
extension MotelRoomViewController: PlaceholderDelegate {
    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        (view as? CollectionView)?.showDefault()
        refreshPage()
    }
}
