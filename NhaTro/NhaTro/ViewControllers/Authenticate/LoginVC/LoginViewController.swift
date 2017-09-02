//
//  LoginViewController.swift
//  NhaTro
//
//  Created by HOANGHUNG on 8/25/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

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
    @IBAction func btnLoginFaceBook(_ sender: Any) {
    }
    @IBAction func btnLoginGoogle(_ sender: Any) {
    }
    
    @IBAction func btnLoginPhone(_ sender: Any) {
        let loginPhone = storyboard?.instantiateViewController(withIdentifier: "RegisterVC")  as! RegisterViewController
        self.present(loginPhone, animated: true, completion: nil)
    }

 

}
