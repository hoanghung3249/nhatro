//
//  RegisterViewController.swift
//  NhaTro
//
//  Created by DUY on 9/2/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
import NKVPhonePicker

class RegisterViewController: UIViewController {

    @IBOutlet weak var txtCountryCode: NKVPhonePickerTextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var segmentedControl: XMSegmentedControl!
    
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupSegmented()
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
    
    
    //MARK:- Action buttons
    
    @IBAction func Back(_ sender: UIButton) {
                dismiss(animated: true, completion: nil)
    }
    @IBAction func nextStep(_ sender: UIButton) {
        let verifyVC = Storyboard.main.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
        self.pushTo(verifyVC)
    }
    

}

//MARK:- Segmented Delegate
extension RegisterViewController: XMSegmentedControlDelegate {
    
    func xmSegmentedControl(_ xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        print("SegmentedControl Selected Segment: \(selectedSegment)")
    }
}





