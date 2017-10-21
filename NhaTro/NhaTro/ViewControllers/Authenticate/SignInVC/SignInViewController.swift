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
    
    @IBOutlet weak var txtResendEmail: UITextField!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var vwForgotPass: UIView!
    @IBOutlet weak var lctTopBtnBack: NSLayoutConstraint!
    
    var changeEmailViewLctTop:NSLayoutConstraint!
    fileprivate var isChangeView:Bool = true
    var vwBlur:UIView!
    
    
    fileprivate let parser:ParseDataSignIn = ParseDataSignIn()

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupForgotPassView()
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


    //MARK:- Support functions
    private func setupUI() {
        let btnAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
        
        let stringAttribute = NSMutableAttributedString(string: "Forgot Password?", attributes: btnAttributes)
        let stringAttribute1 = NSMutableAttributedString(string: "Register with Email?", attributes: btnAttributes)
        btnForgotPass.setAttributedTitle(stringAttribute, for: .normal)
        btnRegister.setAttributedTitle(stringAttribute1, for: .normal)
        
        if #available(iOS 11, *) {
            lctTopBtnBack.constant = 52
        } else {
            lctTopBtnBack.constant = 20
        }
        
    }
    
    fileprivate func setupForgotPassView() {
        //Setup change phone number view
        self.vwBlur = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.vwBlur.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        self.view.insertSubview(self.vwForgotPass, belowSubview: self.view)
        self.view.insertSubview(self.vwBlur, belowSubview: vwForgotPass)
        self.vwBlur.isHidden = true
        self.vwBlur.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissView))
        self.vwBlur.addGestureRecognizer(tap)
        self.vwForgotPass.translatesAutoresizingMaskIntoConstraints = false
        self.vwForgotPass.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.changeEmailViewLctTop = NSLayoutConstraint.init(item: self.vwForgotPass, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 1000)
        self.changeEmailViewLctTop.isActive = true
        self.vwForgotPass.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
        self.vwForgotPass.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        self.vwForgotPass.layer.cornerRadius = 3
        self.vwForgotPass.layer.borderWidth = 0
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
//        let tabVC = TabBarViewController()
//        self.present(tabVC, animated: true, completion: nil)
        
    }
    
    @IBAction func RegisterEmail(_ sender: UIButton) {
        let registerVC = Storyboard.main.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.pushTo(registerVC)
    }
    
    @IBAction func forgotPass(_ sender: UIButton) {
        if self.isChangeView {
            self.isChangeView = false
            self.changeEmailViewLctTop.constant = self.view.frame.size.height / 2 - self.vwForgotPass.frame.size.height
            self.vwBlur.isHidden = false
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func resendEmail(_ sender: UIButton) {
        guard let email = self.txtResendEmail.text else { return }
        if email.isEmptyOrWhitespace() {
            self.showAlert(with: "Please input the email!")
            return
        }
        if !email.isValidEmail() {
            self.showAlert(with: "The email format is invalid.")
            return
        }
        var param:[String:AnyObject] = Dictionary()
        param.updateValue(email as AnyObject, forKey: "email")
        self.callAPIForgotPass(param)
    }
    
    @objc func dismissView() {
        self.view.endEditing(true)
        if !(self.isChangeView) {
            self.isChangeView = true
            self.changeEmailViewLctTop.constant = 1000
            self.vwBlur.isHidden = true
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
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
    
    fileprivate func callAPIForgotPass(_ param:[String:AnyObject]) {
        ProgressView.shared.show(self.view)
        NetworkService.requestWith(.post, url: Constant.APIKey.forgotPass, parameters: param) { [weak self] (data, error, code) in
            guard let strongSelf = self else { return }
            ProgressView.shared.hide()
            if error == nil {
                Utilities.shared.showAlerControler(title: "SUCCESS", message: "Please checking your email account!", confirmButtonText: "OK", cancelButtonText: nil, atController: strongSelf, completion: { (bool) in
                    if bool {
                        strongSelf.dismissView()
                    }
                })
            } else {
                strongSelf.showAlert(with: error!)
            }
        }
        
    }
    
    
}




