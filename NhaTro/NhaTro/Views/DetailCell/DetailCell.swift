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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUIImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func setupUIImage() {
        self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width / 2
        self.imgUser.clipsToBounds = true
    }
    

}
