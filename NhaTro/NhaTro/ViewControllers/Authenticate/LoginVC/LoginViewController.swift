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
        loginFaceBook()
        ProgressView.shared.hide()
    }
    @IBAction func loginGoogle(_ sender: UIButton) {
        ProgressView.shared.show(self.view)

    }

    @IBAction func loginPhone(_ sender: UIButton) {
        let registerVC = Storyboard.main.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.pushTo(registerVC)

    }
    func loginFaceBook(){
        let loginfaceBook:FBSDKLoginManager = FBSDKLoginManager()
        ProgressView.shared.show(self.view)
        loginfaceBook.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error == nil {
                ProgressView.shared.hide()
                let fbloginresult:FBSDKLoginManagerLoginResult = result!
                if FBSDKAccessToken.current() != nil {
                    FBSDKGraphRequest(graphPath: "Me", parameters: ["fields":"id,email,name"]).start(completionHandler: { (concect, result, error) in
                        if error == nil{
                            let value = result as! Dictionary<String,AnyObject>
                            let link:String = value["id"] as! String
                            let avatar:String = "https://graph.facebook.com/\(link)/picture"
                        }
                    })
                }
            }else{
                
            }
        }
    }

    

 

}
