//
//  PostViewController.swift
//  NhaTro
//
//  Created by HOANGHUNG on 9/20/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupNavigation()
    }

    
    //MARK:- Support function
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.barTintColor = Color.mainColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: Font.fontCenturyGothicBold(20),NSForegroundColorAttributeName : UIColor.white]
        self.navigationItem.title = "Đăng Tin"
    }
    

}
