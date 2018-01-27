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
    var motel:Motel?
    var sizeCell: CGFloat = 0.0
    var sizeImgCell: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
     private func setupCollectionView(){
        cvwImageDeatil.delegate = self
        cvwImageDeatil.dataSource = self
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configImageDetailCell(_ motel:Motel, viewSize: CGFloat) {
        self.motel = motel
        self.sizeCell = viewSize
        //Setup layout for item in collectionview
        let layout = UICollectionViewFlowLayout()
        sizeImgCell = sizeCell / 4 - 12.5
        layout.itemSize = CGSize(width: sizeImgCell, height: sizeImgCell)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        cvwImageDeatil.collectionViewLayout = layout
    }

}

// MARK: - CollectionView Datasouce & Delegate
extension ImageDetailCell:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let motel = motel else { return 0 }
        return motel.images.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        sizeImgCell = sizeCell / 4 - 12.5
        return CGSize(width: sizeImgCell, height: sizeImgCell)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageDetailCollectionViewCell
        guard let motelImage = motel?.images[indexPath.row] else { return UICollectionViewCell() }
        cell.configCell(motelImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let actionClick = self.completionHandler else { return }
        actionClick(indexPath)
    }
}

