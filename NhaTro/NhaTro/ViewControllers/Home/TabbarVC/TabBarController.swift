//
//  TabBarController.swift
//  NhaTro
//
//  Created by DUY on 9/15/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class TabBarController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.barTintColor = Color.mainColor()
        self.tabBarController?.tabBar.backgroundColor = Color.mainColor()
        self.tabBarController?.tabBar.tintColor = Color.mainColor()
        // Do any additional setup after loading the view.
    }


}
