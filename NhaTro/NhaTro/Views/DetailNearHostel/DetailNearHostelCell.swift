//
//  DetailNearHostelCell.swift
//  NhaTro
//
//  Created by DUY on 11/20/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class DetailNearHostelCell: UITableViewCell {

    @IBOutlet weak var cvwHostel: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCollectionView() {
        cvwHostel.delegate = self
        cvwHostel.dataSource = self
        //Setup layout for item in collectionview
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.contentView.frame.size.width, height: 181)
        layout.scrollDirection = .vertical
        cvwHostel.collectionViewLayout = layout
        cvwHostel.isScrollEnabled = false
        
        //Register cell for collectionView
        let nib = UINib(nibName: "HomePageCell", bundle: nil)
        cvwHostel.register(nib, forCellWithReuseIdentifier: "HomePageCollectionViewCell")
    }

}

// MARK: - CollectionView Datasoure & Delegate
extension DetailNearHostelCell: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ofType: HomePageCollectionViewCell.self, at: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.contentView.frame.size.width, height: 181)
    }
    
}
