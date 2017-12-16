//
//  DetailCell.swift
//  NhaTro
//
//  Created by DUY on 11/20/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblArea: UILabel!
    @IBOutlet weak var txvDes: UITextView!
    @IBOutlet weak var lblCreateDay: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var vwInfo: UIView!
    @IBOutlet weak var vwBoundsTextView: UIView!
    @IBOutlet weak var vwContent: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUIImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUIImage() {
        self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width / 2
        self.imgUser.clipsToBounds = true
    }
    
    func configDetailCell(_ motel: Motel) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.lblAddress.text = motel.location
            strongSelf.lblPhone.text = motel.phone
            strongSelf.lblArea.text = "\(motel.area)"
            strongSelf.lblPrice.text = "\(motel.unit_price)"
            strongSelf.lblName.text = "\(motel.firstName) \(motel.lastName)"
            strongSelf.txvDes.text = motel.description
            let urlAvatar = URL(string: "\(Constant.APIKey.baseUrl)\(motel.avatar)")
            strongSelf.imgUser.kf.setImage(with: urlAvatar)
        }
    }
}
