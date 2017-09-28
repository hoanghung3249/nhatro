//
//  SignInViewController.swift
//  NhaTro
//
//  Created by DUY on 9/24/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var btnForgotPass: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    fileprivate let parser:ParseDataSignIn = ParseDataSignIn()

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


    //MARK:- Support functions
    private func setupUI() {
        let btnAttributes : [String: Any] = [
            NSForegroundColorAttributeName : UIColor.white,
            NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
        let stringAttribute = NSMutableAttributedString(string: "Forgot Password?", attributes: btnAttributes)
        let stringAttribute1 = NSMutableAttributedString(string: "Register with Email?", attributes: btnAttributes)
        btnForgotPass.setAttributedTitle(stringAttribute, for: .normal)
        btnRegister.setAttributedTitle(stringAttribute1, for: .normal)

    }
    
    
    //MARK:- Action buttons
    @IBAction func Back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func SignIn(_ sender: UIButton) {
        guard let email = self.txtEmail.text, let pass = self.txtPassword.text else {
            return
        }
        let (params,error) = Params.createParamLogin(email, pass)
        if let params = params {
            self.callAPILogin(params)
        } else if let error = error {
            self.showAlert(with: error)
        }
        
    }
    
    @IBAction func RegisterEmail(_ sender: UIButton) {
        let registerVC = Storyboard.main.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.pushTo(registerVC)
    }
    
    
}

//MARK:- Support API
extension SignInViewController {
    
    fileprivate func callAPILogin(_ params:[String:AnyObject]) {
        ProgressView.shared.show(self.view)
        NetworkService.requestWith(.post, url: Constant.APIKey.login, parameters: params) { [weak self] (data, error, code) in
            guard let strongSelf = self else { return }
            ProgressView.shared.hide()
            if error == nil {
                if let data = data {
                    let dataJSON = JSON(data)
                    print(dataJSON)
                    strongSelf.parser.fetchDataSignIn(data: dataJSON)
                    Utilities.shared.delayWithSeconds(0.5, completion: {
                        let tabVC = TabBarViewController()
                        strongSelf.present(tabVC, animated: true, completion: nil)
                    })
                }
            } else {
                strongSelf.showAlert(with: error!)
            }
        }
    }
    
    
}




