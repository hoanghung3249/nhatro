//
//  ImageDetailCollectionViewCell.swift
//  NhaTro
//
//  Created by DUY on 11/20/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class ImageDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgDetail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell(_ motelImage: MotelImage) {
        let urlImg = URL(string: "\(Constant.APIKey.baseUrl)\(motelImage.sub_image_thumb)")
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.imgDetail.kf.setImage(with: urlImg)
        }
    }

}
