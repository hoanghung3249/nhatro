//
//  FavoriteViewController.swift
//  NhaTro
//
//  Created by HOANGHUNG on 9/20/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
import HGPlaceholders
import RealmSwift

class FavoriteViewController: UIViewController {

    // MARK: - Outlets and Variables
    @IBOutlet weak var cvwFavorite: CollectionView!
    
    fileprivate var placeholderCollectionView: CollectionView? {
        get { return cvwFavorite }
    }
    
    fileprivate var arrMotel = [Motel]()
    fileprivate var motels = [MotelRealm]()
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.cvwFavorite.reloadData()
        }
    }
    
    //MARK:- Support functions
    private func getListMotel() {
        let realm = RealmUtilities.getRealmInstanse()
        let motelsRealm = realm.objects(MotelRealm.self)
        motelsRealm.forEach { (motel) in
            motels.append(motel)
        }
        DispatchQueue.main.async {
            self.cvwFavorite.reloadData()
        }
    }
    
    private func setupCollectionView() {
        cvwFavorite.delegate = self
        cvwFavorite.dataSource = self
        //Setup layout for item in collectionview
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: 181)
        layout.scrollDirection = .vertical
        cvwFavorite.collectionViewLayout = layout
        
        //Register cell for collectionView
        let nib = UINib(nibName: "HomePageCell", bundle: nil)
        cvwFavorite.register(nib, forCellWithReuseIdentifier: "HomePageCollectionViewCell")
//        loadMoreView.delegate = self
//        refreshView.delegate = self
//        cvwFavorite.addPullLoadableView(loadMoreView, type: .loadMore)
//        cvwFavorite.addPullLoadableView(refreshView, type: .refresh)
        setupPlaceholder()
    }
    
    private func setupPlaceholder() {
        placeholderCollectionView?.placeholderDelegate = self
        placeholderCollectionView?.placeholdersProvider = .nhatroProvider
        placeholderCollectionView?.showLoadingPlaceholder()
    }
}

// MARK: - CollectionView DataSource and Delegate
extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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

// MARK: - Placeholder delegate
extension FavoriteViewController: PlaceholderDelegate {
    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        (view as? CollectionView)?.showDefault()
//        refreshPage()
    }
}

