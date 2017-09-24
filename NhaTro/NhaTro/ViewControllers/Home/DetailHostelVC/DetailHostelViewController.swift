//
//  DetailHostelViewController.swift
//  NhaTro
//
//  Created by DUY on 9/24/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class DetailHostelViewController: UIViewController {

    
    @IBOutlet weak var vwContain: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetail()
        // Do any additional setup after loading the view.
    }
    
    private func loadDetail(){
        let detailView = DetailHostelView.fromNib(nibName: "DetailHostel")
        vwContain.addSubview(detailView)
    }
    

}
