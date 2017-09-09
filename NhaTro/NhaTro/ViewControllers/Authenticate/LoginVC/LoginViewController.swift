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
import SwiftyJSON

class LoginViewController: UIViewController {

    var google:Google?
    var facebook:FacebookModel?
    
    
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
    
    fileprivate func loginFacebook() {
        Facebook.loginWithFacebook(viewcontroller: self, { [weak self] (dataFB) in
            guard let strongSelf = self else { return }
            if let dataJSON = dataFB {
                strongSelf.facebook = FacebookModel(dataJSON)
            }
        }) { [weak self] (error, code) in
            guard let strongSelf = self else { return }
            strongSelf.showAlert(with: error)
        }
    }
    
    
    //MARK:- Action button
    
    @IBAction func loginFacebook(_ sender: UIButton) {
        loginFacebook()
    }
    @IBAction func loginGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }

    @IBAction func loginPhone(_ sender: UIButton) {
        let registerVC = Storyboard.main.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.pushTo(registerVC)

    }
}


//MARK:- Google Delegate
extension LoginViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let userProfile = user else { return }
        self.google = Google(userProfile)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print(user.profile)
    }
    
}



