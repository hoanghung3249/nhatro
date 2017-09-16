//
//  VerifyViewController.swift
//  NhaTro
//
//  Created by DUY on 9/3/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController {
    
    
    @IBOutlet weak var txtConfirmCode: UITextField!
    @IBOutlet weak var btnResendCode: UIButton!
    
    
    //MARK:- Life Cyle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    
    //MARK:- Support functions
    private func setupUI() {
        self.btnResendCode.contentHorizontalAlignment = .left
        self.txtConfirmCode.underlined(UIColor.white)
        let btnAttributes : [String: Any] = [
            NSForegroundColorAttributeName : UIColor.white,
            NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
        let stringAttribute = NSMutableAttributedString(string: "Didn’t receive it?", attributes: btnAttributes)
        btnResendCode.setAttributedTitle(stringAttribute, for: .normal)
    }

    
    
    //MARK:- Action buttons
    
    @IBAction func Back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func login(_ sender: UIButton) {
        let tabbar = Storyboard.home.instantiateViewController(withIdentifier: "TabBarVC") as! UITabBarController
        self.pushTo(tabbar)
    }
   

}

