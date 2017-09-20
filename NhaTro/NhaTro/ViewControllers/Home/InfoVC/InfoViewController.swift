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
        self.setupNavigation()
    }

    
    
    //MARK:- Support function
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.barTintColor = Color.mainColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: Font.fontCenturyGothicBold(20),NSForegroundColorAttributeName : UIColor.white]
//        self.navigationItem.title = "Home"
    }
    
    //MARK:- Action buttons
    @IBAction func logOut(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
