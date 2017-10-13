//
//  ChangePassViewController.swift
//  NhaTro
//
//  Created by HOANGHUNG on 10/6/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class ChangePassViewController: UIViewController {

    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    
    
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupNavigation()
    }

    
    
    //MARK:- Support functions
    fileprivate func setupNavigation() {
        self.navigationItem.title = "Change Password"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowLeftSimpleLineIcons"), style: .done, target: self, action: #selector(ChangePassViewController.dismissView))
    }
    
    
    
    //MARK:- Action buttons
    @IBAction func saveNewPass(_ sender: UIButton) {
        guard let newPass = self.txtNewPass.text, let confirmPass = self.txtConfirmPass.text else { return }
        let (params,error) = Params.createParamChangePass(newPass, confirmPass)
        if let params = params {
            self.callAPIChangePass(params)
        } else if let error = error {
            self.showAlert(with: error)
        }
    }
    
    @objc func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }

}


//MARK:- Support API
extension ChangePassViewController {
    
    fileprivate func callAPIChangePass(_ params:[String:AnyObject]) {
        ProgressView.shared.show((self.parent?.view)!)
        
        if let userData = USER {
            NetworkService.requestWithHeader(.post, userData.token, url: Constant.APIKey.changePass, parameters: params, Completion: { [weak self] (data, error, code) in
                guard let strongSelf = self else { return }
                ProgressView.shared.hide()
                if let code = code {
                    if code == StatusCode.success {
                        Utilities.shared.showAlerControler(title: "Success", message: error!, confirmButtonText: "OK", cancelButtonText: nil, atController: strongSelf, completion: { (bool) in
                            if bool {
                                strongSelf.navigationController?.popViewController(animated: true)
                            }
                        })
                    } else {
                        strongSelf.showAlert(with: error!)
                    }
                }
            })
        }
        
    }
    
    
}


