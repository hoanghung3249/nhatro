//
//  ImageCollectionViewCell.swift
//  NhaTro
//
//  Created by DUY on 10/17/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgHinh: UIImageView!
    
    func configCell(_ image: UIImage) {
        imgHinh.image = image
    }

}
