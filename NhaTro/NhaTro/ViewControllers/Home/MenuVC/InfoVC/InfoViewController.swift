//
//  InfoViewController.swift
//  NhaTro
//
//  Created by HOANGHUNG on 10/5/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
import NKVPhonePicker

class InfoViewController: UIViewController {
    

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var segmentedControl: XMSegmentedControl!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtCountryCode: NKVPhonePickerTextField!
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    
    
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
    }

    
    //MARK:- Support functions
    
    private func setupUI() {
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width / 2
        self.imgProfile.clipsToBounds = true
        self.setupSegmented()
    }
    
    private func setupSegmented() {
        segmentedControl.delegate = self
        segmentedControl.backgroundColor = UIColor.white
        let arrTitle = ["User", "Host"]
        let arrIcon = [UIImage(named: "ionPersonStalkerIonicons")!,UIImage(named: "homeAnticon")!]
        segmentedControl.segmentContent = (arrTitle,arrIcon)
        segmentedControl.layer.borderColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1).cgColor
        segmentedControl.layer.borderWidth = 0.5
        segmentedControl.tint = .black
        segmentedControl.highlightTint = .black
        segmentedControl.highlightColor = UIColor(red: 255.0/255.0, green: 173.0/255.0, blue: 14.0/255.0, alpha: 1)
        segmentedControl.layer.cornerRadius = 20
        
    }
    
    
    

}



//MARK:- Segmented Delegate
extension InfoViewController: XMSegmentedControlDelegate {
    
    func xmSegmentedControl(_ xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        print("SegmentedControl Selected Segment: \(selectedSegment)")
    }
}
