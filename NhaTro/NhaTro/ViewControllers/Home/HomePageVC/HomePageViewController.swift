//
//  HomePageViewController.swift
//  NhaTro
//
//  Created by DUY on 9/15/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var cvwDetails: UICollectionView!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setupNavigation()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Support functions
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
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.barTintColor = Color.mainColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: Font.fontCenturyGothicBold(20),NSForegroundColorAttributeName : UIColor.white]
        self.navigationItem.title = "Home"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }



}

//MARK:- CollectionView Datasource & Delegate
extension HomePageViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageCell", for: indexPath) as! HomePageCollectionViewCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 181)
    }
    
}
