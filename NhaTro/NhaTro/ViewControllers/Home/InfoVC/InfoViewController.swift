//
//  InfoViewController.swift
//  NhaTro
//
//  Created by HOANGHUNG on 9/17/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    //MARK:- Support function
    
    //MARK:- Action buttons
    @IBAction func logOut(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
