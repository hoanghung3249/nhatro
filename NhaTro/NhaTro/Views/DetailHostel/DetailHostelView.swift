//
//  DetailHostelView.swift
//  NhaTro
//
//  Created by DUY on 9/24/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class DetailHostelView: UIView {
    
    @IBOutlet weak var txtvDescribe: UITextView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblArena: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!

    @IBOutlet weak var lblDate: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        setupView()
    }
    
    
    private func setupView() {
        if let view = Bundle.main.loadNibNamed("DetailHostel", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(view)
        }
        
    }
    
}
