//
//  MenuCell.swift
//  NhaTro
//
//  Created by HOANGHUNG on 9/25/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupMenuCell(_ title:String,_ icon:String) {
        self.lblTitle.text = title
        self.imgIcon.image = UIImage(named: icon)
    }

}
