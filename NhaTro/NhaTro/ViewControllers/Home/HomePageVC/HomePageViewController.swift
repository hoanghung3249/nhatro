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
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.title = "Home"
        tabBarController?.tabBar.isHidden = false
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func showMap(_ sender: UIButton) {
        let showMap = Storyboard.home.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(showMap!, animated: true)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = storyboard?.instantiateViewController(withIdentifier: "DetailHostelViewController") as! DetailHostelViewController
        self.present(detail, animated: true, completion: nil)
    }
}
