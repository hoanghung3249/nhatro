//
//  HeaderImageCell.swift
//  NhaTro
//
//  Created by DUY on 11/20/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
import Kingfisher

class HeaderImageCell: UITableViewCell {
    
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    var actionButton: ((_ sender: UIButton)->())?
    
    @IBAction func like(_ sender: UIButton) {
        guard let actionButton = actionButton else { return }
        actionButton(sender)
    }
    
    @IBAction func share(_ sender: UIButton) {
        guard let actionButton = actionButton else { return }
        actionButton(sender)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configHeaderCell(_ motel:Motel) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.lblPhone.text = motel.phone
            strongSelf.lblPrice.text = "\(motel.unit_price) VNĐ"
            strongSelf.lblLocation.text = motel.location
            if motel.images.count > 0 {
                let subImage = motel.images[0].sub_image_thumb
                let url = URL(string: "\(Constant.APIKey.baseUrl)\(subImage)")
                strongSelf.imgHeader.kf.setImage(with: url)
            }
        }
    }

}
