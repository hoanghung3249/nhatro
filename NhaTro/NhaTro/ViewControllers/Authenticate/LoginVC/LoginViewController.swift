//
//  LoginViewController.swift
//  NhaTro
//
//  Created by HOANGHUNG on 8/25/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var vwBound: UIView!
    @IBOutlet weak var vwLogin: UIView!
    @IBOutlet weak var lctWidthImgLogo: NSLayoutConstraint!
    @IBOutlet weak var lctCenterYImgLogo: NSLayoutConstraint!
    @IBOutlet weak var lctHeightImgLogo: NSLayoutConstraint!
    
    var google:Google?
    var facebook:FacebookModel?
    
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupGoogle()
        self.setupUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    //MARK:- Support function
    
    fileprivate func setupGoogle() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    fileprivate func setupUI() {
        self.vwLogin.isHidden = true
        self.lctWidthImgLogo.constant = 210
        self.lctHeightImgLogo.constant = 85
        Utilities.shared.delayWithSeconds(1) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showView()
        }
    }
    
    
    fileprivate func showView() {
        self.lctWidthImgLogo.constant = 130
        self.lctHeightImgLogo.constant = 50
        let imgTopContraint = self.lctCenterYImgLogo.constraintWithMultiplier(1/3)
        self.view.removeConstraint(self.lctCenterYImgLogo)
        self.lctCenterYImgLogo = imgTopContraint
        self.view.addConstraint(lctCenterYImgLogo)
        self.vwLogin.isHidden = false
        self.vwBound.backgroundColor = .clear
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        })
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



