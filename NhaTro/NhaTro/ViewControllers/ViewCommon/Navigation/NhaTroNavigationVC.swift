//
//  NhaTroNavigationVC.swift
//  NhaTro
//
//  Created by HOANGHUNG on 9/20/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class NhaTroNavigationVC: UINavigationController {

    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupBasicView()
    }
    
    
    //MARK:- Support function
    private func setupBasicView() {
        self.navigationBar.barTintColor = Color.mainColor()
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: Font.fontCenturyGothicBold(20),NSAttributedStringKey.foregroundColor : UIColor.white]
    }

    
    public func setupTitle(_ titleName:String) {
        self.navigationBar.topItem?.title = titleName
    }
    
    
    

}
