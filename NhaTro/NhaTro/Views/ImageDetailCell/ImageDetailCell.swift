//
//  ImageDetailCell.swift
//  NhaTro
//
//  Created by DUY on 11/20/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class ImageDetailCell: UITableViewCell {
    
    @IBOutlet weak var cvwImageDeatil: UICollectionView!
    var completionHandler:((_ indexPath:IndexPath)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        // Initialization code
    }
    
     private func setupCollectionView(){
        cvwImageDeatil.delegate = self
        cvwImageDeatil.dataSource = self
        //Setup layout for item in collectionview
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        cvwImageDeatil.collectionViewLayout = layout

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

// MARK: - CollectionView Datasouce & Delegate
extension ImageDetailCell:UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageDetailCollectionViewCell
  
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let actionClick = self.completionHandler else { return }
        actionClick(indexPath)
        
    }
    
}

