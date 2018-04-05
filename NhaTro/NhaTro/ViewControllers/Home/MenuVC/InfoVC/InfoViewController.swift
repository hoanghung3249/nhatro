//
//  InfoViewController.swift
//  NhaTro
//
//  Created by HOANGHUNG on 10/5/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
import NKVPhonePicker
import GooglePlaces
import TLPhotoPicker
import Kingfisher
import Photos

class InfoViewController: UIViewController {
    
    //MARK: - Outlets and variables
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var segmentedControl: XMSegmentedControl!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtCountryCode: NKVPhonePickerTextField!
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var btnEdit: UIButton!
    
    fileprivate var userLocation:CLLocationCoordinate2D?
    fileprivate var autocompleteController:GMSAutocompleteViewController?
    
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    //MARK:- Support functions
    
    private func setupUI() {
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width / 2
        self.imgProfile.clipsToBounds = true
        txtAddress.delegate = self
        self.setupSegmented()
        self.setupNavigation()
        self.setupData()
        self.setupTextField(false)
        setupActionForImg()
        guard let userData = USER else { return }
        if userData.roleId != 2 {
            segmentedControl.selectedSegment = 1
        }
    }
    
    private func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowLeftSimpleLineIcons"), style: .done, target: self, action: #selector(InfoViewController.dismissView))
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
        self.segmentedControl.isUserInteractionEnabled = isActive
    }
    
    private func createParamEditProfile(_ phone:String, _ first_name:String, _ last_name:String, _ address:String, _ userImage:UIImageView?, _ userLocation:CLLocationCoordinate2D) {
        let (param,error) = Params.createParamUpdateProfile(phone, first_name, last_name, address, userLocation)
        if let error = error {
            showAlert(with: error)
        } else {
            guard let param = param else { return }
            var imageProfile = [UIImage]()
            if userImage?.image != nil {
                guard let imgProfile = userImage?.image else { return }
                imageProfile.append(imgProfile)
            }
            callAPIEditProfile(param, "image", imageProfile)
        }
    }
    
    //MARK:- Action buttons
    
    @objc func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func selectPhoto() {
        let viewController = TLPhotosPickerViewController()
        viewController.delegate = self
        viewController.configure.mediaType = PHAssetMediaType.image
        viewController.configure.usedCameraButton = true
        viewController.configure.maxSelectedAssets = 1
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func editProfile(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            setupTextField(true)
        } else {
            setupTextField(false)
            guard let phone = txtPhoneNumber.text, let first_name = txtFirstName.text, let last_name = txtLastName.text, let address = txtAddress.text, let userLocation = userLocation else { return }
            createParamEditProfile(phone, first_name, last_name, address, imgProfile, userLocation)
        }
    }
}

//MARK:- Segmented Delegate
extension InfoViewController: XMSegmentedControlDelegate {
    
    func xmSegmentedControl(_ xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        print("SegmentedControl Selected Segment: \(selectedSegment)")
        guard let userData = USER else { return }
        if selectedSegment == 1 && userData.active == 0 {
            callAPIUpdateRole()
        }
    }
    
    private func callAPIUpdateRole() {
        ProgressView.shared.show((self.parent?.view)!)
        DataCenter.shared.callAPIUpdateRole { [weak self] (success, mess) in
            guard let strongSelf = self else { return }
            ProgressView.shared.hide()
            if success {
                strongSelf.showAlertSuccess(with: "Nâng cấp tài khoản thành công!")
                UserDefaults.setValue(true, forKey: .isSendMailActive)
            } else {
                guard let err = mess else { return }
                strongSelf.segmentedControl.selectedSegment = 0
                strongSelf.showAlert(with: err)
            }
        }
    }
}

//MARK:- Support API
extension InfoViewController {
    fileprivate func callAPIEditProfile(_ params:[String:Any], _ imgName:String, _ imageProfile:[UIImage]) {
        ProgressView.shared.show((self.parent?.view)!)
        DataCenter.shared.callAPIEditProfile(params, imgName, imageProfile, { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            ProgressView.shared.hide()
            if success {
                strongSelf.showAlertSuccess(with: "Cập nhật thông tin thành công!")
            } else {
                guard let err = error else { return }
                strongSelf.showAlert(with: err)
            }
        })
    }
}

extension InfoViewController: TLPhotosPickerViewControllerDelegate {
    
    //TLPhotosPickerViewControllerDelegate
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // use selected order, fullresolution image
        guard let imagePicker = withTLPHAssets.first else { return }
        guard let imageFullSize = imagePicker.fullResolutionImage else { return }
        let imageData = UIImageJPEGRepresentation(imageFullSize, 0.1)
        DispatchQueue.main.async {
            self.imgProfile.image = UIImage(data: imageData!)
        }
    }
    //    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
    //        // if you want to used phasset.
    //    }
    func photoPickerDidCancel() {
        // cancel
    }
    func dismissComplete() {
        // picker viewcontroller dismiss completion
    }
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        // exceed max selection
    }
    
}

// MARK: - Textfield Delegate
extension InfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.endEditing(true)
        autocompleteController = GMSAutocompleteViewController()
        autocompleteController?.delegate = self
        DispatchQueue.main.async {
            self.present(self.autocompleteController!, animated: true, completion: nil)
        }
    }
}
// MARK: - AutocompleteController Delegate
extension InfoViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        userLocation = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        if let address = place.formattedAddress {
            txtAddress.text = address
        }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
