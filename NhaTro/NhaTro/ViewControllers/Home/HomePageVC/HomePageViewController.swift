//
//  HomePageViewController.swift
//  NhaTro
//
//  Created by DUY on 9/15/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    @IBOutlet weak var CoHienthi: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoHienthi.delegate = self
        CoHienthi.dataSource = self
        self.navigationController?.navigationBar.barTintColor = Color.mainColor()

        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }



}
extension HomePageViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomePageCollectionViewCell
        return cell
    }
}
