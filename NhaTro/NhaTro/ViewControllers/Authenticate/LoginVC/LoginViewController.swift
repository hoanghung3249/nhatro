//
//  LoginViewController.swift
//  NhaTro
//
//  Created by HOANGHUNG on 8/25/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController {

    
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
   override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK:- Action button
    
    @IBAction func loginFacebook(_ sender: UIButton) {
    }
    @IBAction func loginGoogle(_ sender: UIButton) {
    }

    @IBAction func loginPhone(_ sender: UIButton) {
        let registerVC = Storyboard.main.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.pushTo(registerVC)

    }
    

 

}
