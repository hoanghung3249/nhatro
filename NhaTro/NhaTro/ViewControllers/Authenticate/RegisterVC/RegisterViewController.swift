//
//  RegisterViewController.swift
//  NhaTro
//
//  Created by DUY on 9/2/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
import NKVPhonePicker
import SwiftyJSON

class RegisterViewController: UIViewController {

    @IBOutlet weak var txtConfirmPassWord: UITextField!
    @IBOutlet weak var txtPassWord: UITextField!
    @IBOutlet weak var txtCountryCode: NKVPhonePickerTextField!
    @IBOutlet weak var txtEmail: UITextField!

    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var segmentedControl: XMSegmentedControl!
    
    let parser:ParseDataSignIn = ParseDataSignIn()
    
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.setupSegmented()
        self.setupDelegate()
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK:- Support functions
    private func setupSegmented() {
        segmentedControl.delegate = self
        segmentedControl.backgroundColor = UIColor(red: 74.0/255, green: 74.0/255, blue: 74.0/255, alpha: 0.8)
        let arrTitle = ["User", "Host"]
        let arrIcon = [UIImage(named: "ionPersonStalkerIonicons")!,UIImage(named: "homeAnticon")!]
        segmentedControl.segmentContent = (arrTitle,arrIcon)
        segmentedControl.highlightColor = UIColor(red: 238.0/255.0, green: 173.0/255.0, blue: 14.0/255.0, alpha: 1)
        segmentedControl.layer.cornerRadius = 20
        
    }
    
    private func setupDelegate() {
        self.txtCountryCode.delegate = self
    }
    
    
    //MARK:- Action buttons
    
    @IBAction func Back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextStep(_ sender: UIButton) {
//        let verifyVC = Storyboard.main.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
//        self.pushTo(verifyVC)
        guard let email = self.txtEmail.text, let pass = self.txtPassWord.text, let phone = self.txtPhoneNumber.text, let firstName = self.txtFirstName.text, let lastName = self.txtLastName.text else { return }
        let params = self.createParamRegister(email, pass, firstName, lastName, phone)
        self.register(params)
    }
    

}

//MARK:- Segmented Delegate
extension RegisterViewController: XMSegmentedControlDelegate {
    
    func xmSegmentedControl(_ xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        print("SegmentedControl Selected Segment: \(selectedSegment)")
    }
}

//MARK:- Textfield Delegate
extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtCountryCode {
            self.view.endEditing(true)
        }
    }
    
}


//MARK:- Support API
extension RegisterViewController {
    
    fileprivate func createParamRegister(_ email:String,_ pass:String,_ firstName:String,_ lastName:String,_ phone:String ) -> [String:AnyObject] {
        
        var params:[String:AnyObject] = Dictionary()
        params.updateValue(email as AnyObject, forKey: "email")
        params.updateValue(pass as AnyObject, forKey: "password")
        params.updateValue(firstName as AnyObject, forKey: "first_name")
        params.updateValue(lastName as AnyObject, forKey: "last_name")
        params.updateValue(phone as AnyObject, forKey: "phone")
        return params
    }
    
    
    fileprivate func register(_ params:[String:AnyObject]) {
        ProgressView.shared.show(self.view)
        NetworkService.requestWith(.post, url: Constant.APIKey.register, parameters: params) { [weak self] (data, error, code) in
            guard let strongSelf = self else { return }
            ProgressView.shared.hide()
            if error == nil {
                if let data = data {
                    let dataJSON = JSON(data)
                    strongSelf.parser.fetchDataSignIn(data: dataJSON)
                }
            } else {
                strongSelf.showAlert(with: error!)
            }
            
        }
    }
    
}





