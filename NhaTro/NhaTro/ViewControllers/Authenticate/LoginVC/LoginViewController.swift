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
import Kingfisher
import GoogleSignIn

class LoginViewController: UIViewController {

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGoogle()
        // Do any additional setup after loading the view.
    }
   override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    //MARK:- Support function
    
    fileprivate func setupGoogle() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    
    
    //MARK:- Action button
    
    @IBAction func loginFacebook(_ sender: UIButton) {
        
    }
    @IBAction func loginGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
        
    }

    @IBAction func loginPhone(_ sender: UIButton) {
        let registerVC = Storyboard.main.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.pushTo(registerVC)

    }
}

extension LoginViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        print(user.profile.name)
        print(user.profile.email)
        print(user.userID)
        print(user.authentication.idToken)
        print(user.profile.imageURL(withDimension: 400))
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
}



