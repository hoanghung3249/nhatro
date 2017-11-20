//
//  HomePageViewController.swift
//  NhaTro
//
//  Created by DUY on 9/15/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
import KRPullLoader

class HomePageViewController: UIViewController {

    @IBOutlet weak var cvwDetails: UICollectionView!
    fileprivate var arrMotel = [Motel]()
    fileprivate var current_Page:Int = 1
    fileprivate var total_pages:Int = 0
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
        getListMotel(current_Page)
        self.setupCollectionView()
    }
    
    //MARK:- Support functions
    private func setupLayout() {
        tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = "Home"
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
        cvwDetails.register(nib, forCellWithReuseIdentifier: "HomePageCell")
    }
    
    fileprivate func getListMotel(_ page:Int) {
        ProgressView.shared.show(view)
        DataCenter.shared.callAPIGetListMotel(page: page) { [weak self] (success, mess, arrMotel, paging) in
            guard let strongSelf = self else { return }
            ProgressView.shared.hide()
            if success {
                guard let paging = paging else { return }
                strongSelf.total_pages = paging.total_pages
                strongSelf.arrMotel = arrMotel
                DispatchQueue.main.async {
                    strongSelf.cvwDetails.reloadData()
                }
            } else {
                guard let mess = mess else { return }
                strongSelf.showAlert(with: mess)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Action buttons
    @IBAction func showMap(_ sender: UIButton) {
        let showMap = Storyboard.home.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
        self.navigationItem.title = ""
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(showMap!, animated: true)
    }
}

//MARK:- CollectionView Datasource & Delegate
extension HomePageViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMotel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageCell", for: indexPath) as! HomePageCollectionViewCell
        let motel = arrMotel[indexPath.row]
        cell.configHomeCell(motel)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 181)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let detail = storyboard?.instantiateViewController(withIdentifier: "DetailHostelViewController") as! DetailHostelViewController
//        self.present(detail, animated: true, completion: nil)
    }
}
