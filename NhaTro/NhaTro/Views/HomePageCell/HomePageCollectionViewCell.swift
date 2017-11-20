//
//  HomePageCollectionViewCell.swift
//  NhaTro
//
//  Created by DUY on 9/15/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
import Kingfisher

class HomePageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgHinhCell: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblMoney: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    func configHomeCell(_ motel:Motel) {
        lblMoney.text = "\(motel.unit_price) VNĐ"
        lblPhone.text = motel.phone
        lblLocation.text = motel.location
        if motel.images.count > 0 {
            guard let img = motel.images.first else { return }
            let imgThumb = "\(Constant.APIKey.baseUrl)\(img.sub_image_thumb)"
            let url = URL(string: imgThumb)
            imgHinhCell.kf.setImage(with: url)
        } else {
            imgHinhCell.image = UIImage(named: "placeholder")
        }
    }
}
