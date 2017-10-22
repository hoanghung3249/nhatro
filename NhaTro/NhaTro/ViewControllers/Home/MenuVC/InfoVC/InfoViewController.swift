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
    @IBOutlet weak var btnEdit: UIButton!
    
    
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    
    //MARK:- Support functions
    
    private func setupUI() {
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width / 2
        self.imgProfile.clipsToBounds = true
        self.setupSegmented()
        self.setupNavigation()
        self.setupData()
        self.setupTextField(false)
        setupActionForImg()
    }
    
    private func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowLeftSimpleLineIcons"), style: .done, target: self, action: #selector(InfoViewController.dismissView))
    }
    
    private func setupActionForImg() {
        imgProfile.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(InfoViewController.selectPhoto))
        imgProfile.addGestureRecognizer(tapGesture)
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
        segmentedControl.highlightColor = Color.mainColor()
        segmentedControl.layer.cornerRadius = 20
    }
    
    private func setupData() {
        guard let userData = USER else { return }
        self.navigationItem.title = userData.firstName + userData.lastName
        self.txtEmail.text = userData.email
        self.txtFirstName.text = userData.firstName
        self.txtLastName.text = userData.lastName
        self.txtAddress.text = userData.address
        self.txtPhoneNumber.text = userData.phone
    }
    
    fileprivate func setupTextField(_ isActive:Bool) {
        self.txtPhoneNumber.isUserInteractionEnabled = isActive
        self.txtLastName.isUserInteractionEnabled = isActive
        self.txtFirstName.isUserInteractionEnabled = isActive
        self.txtAddress.isUserInteractionEnabled = isActive
        self.txtEmail.isUserInteractionEnabled = isActive
    }
    
    //MARK:- Action buttons
    
    @objc func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func selectPhoto() {
        print("open photo")
    }
    
    @IBAction func editProfile(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            setupTextField(true)
        } else {
            setupTextField(false)
        }
    }
}



//MARK:- Segmented Delegate
extension InfoViewController: XMSegmentedControlDelegate {
    
    func xmSegmentedControl(_ xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        print("SegmentedControl Selected Segment: \(selectedSegment)")
        if selectedSegment == 1 {
            
        }
    }
}

//MARK:- Support API
extension InfoViewController {
    
    fileprivate func callAPIEditProfile(_ params:[String:AnyObject]) {
        ProgressView.shared.show((self.parent?.view)!)
        
        
    }
    
    
}



