//
//  PostViewController.swift
//  NhaTro
//
//  Created by HOANGHUNG on 9/20/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
import TLPhotoPicker
import Photos
import GooglePlaces

class PostViewController: UIViewController {
   
    // MARK: - Outlets and Variables
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var CoView: UICollectionView!
    @IBOutlet weak var txtAcreage: UITextField!
    fileprivate let imgDefault = UIImage(named: "add_image")!
    fileprivate var arrImage:[UIImage] = [UIImage]()
    fileprivate var row:Int = 0
    fileprivate var hostelLocation:CLLocationCoordinate2D?
    fileprivate var autocompleteController:GMSAutocompleteViewController?
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupUI()
        setupDelegate()
    }
    
    //MARK:- Support function
    private func setupUI() {
        self.txtLocation.underlined(Color.txtUnderlineColor())
        self.txtPrice.underlined(Color.txtUnderlineColor())
        self.txtAcreage.underlined(Color.txtUnderlineColor())
        self.txtPhone.underlined(Color.txtUnderlineColor())
        txtAcreage.addTextRightView("m2", Font.fontAvenirNext(12))
        txtPrice.addTextRightView("VNĐ", Font.fontAvenirNext(12))
    }
    
    private func setupCollectionView() {
        arrImage.append(imgDefault)
        CoView.delegate = self
        CoView.dataSource = self
    }
    
    private func setupDelegate() {
        txtView.delegate = self
        txtLocation.delegate = self
    }
    
    // MARK: - Action buttons
    
    fileprivate func selectPhoto(_ row:Int) {
        let photoVC = TLPhotosPickerViewController()
        photoVC.delegate = self
        photoVC.configure.mediaType = PHAssetMediaType.image
        photoVC.configure.usedCameraButton = true
        photoVC.configure.maxSelectedAssets = 1
        self.row = row
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.present(photoVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func postHostel(_ sender: UIButton) {
        guard let area = txtAcreage.text, let address = txtLocation.text, let unitPrice = txtPrice.text, let phone = txtPhone.text, let description = txtView.text, let location = hostelLocation else { return }
        let (param, error) = Params.createParamPostInfo(area: area, address: address, unitPrice: unitPrice, phone: phone, description: description, location: location)
        if error != nil {
            showAlert(with: error!)
        } else {
            guard let param = param else { return }
            callAPIPostHostel(with: param)
        }
    }
    
}

// MARK: - CollectionView DataSource and Delegate
extension PostViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ofType: ImageCollectionViewCell.self, at: indexPath)
        let image = arrImage[indexPath.row]
        cell.configCell(image)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectPhoto(indexPath.row)
    }
}

// MARK: - TextView Delegate
extension PostViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtView.text == "Có chỗ để xe, có thang máy,…"{
            txtView.text = ""
            txtView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtView.text == ""{
            txtView.text = "Có chỗ để xe, có thang máy,…"
            txtView.textColor = UIColor.gray
        }
    }
}

// MARK: - TLPhoto Delegate
extension PostViewController: TLPhotosPickerViewControllerDelegate {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        guard let imagePicker = withTLPHAssets.first else { return }
        guard let imageFullSize = imagePicker.fullResolutionImage else { return }
        let imageData = imageFullSize.resizeToData()
        let img = UIImage(data: imageData)
        var imgPhongTro = arrImage[row]
        if arrImage.count <= 4 && imgPhongTro == imgDefault {
            arrImage.append(imgDefault)
        }
        imgPhongTro = img!
        arrImage[row] = imgPhongTro
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.CoView.reloadData()
        }
    }
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
    }
    func photoPickerDidCancel() {
    }
    func dismissComplete() {
    }
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
    }
}

// MARK: - Textfield Delegate
extension PostViewController: UITextFieldDelegate {
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
extension PostViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        hostelLocation = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        if let address = place.formattedAddress {
            txtLocation.text = address
        }
//        let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
//        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
//            guard let lastPlaceMark = placemarks?.last else { return }
//            print(lastPlaceMark.postalCode)
//            print(lastPlaceMark.isoCountryCode)
//        }
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

// MARK: - Support API
extension PostViewController {
    
    fileprivate func callAPIPostHostel(with param: [String:Any]) {
        ProgressView.shared.show(self.view!)
        DataCenter.shared.callAPIPostHostel(with: param, arrImage: arrImage) { [weak self] (success, mess) in
            guard let strongSelf = self else { return }
            ProgressView.shared.hide()
            if success {
                Utilities.shared.showAlerControler(title: "Thông Báo", message: "Đăng bài thành công!", confirmButtonText: "Ok", cancelButtonText: nil, atController: strongSelf, completion: { (isOk) in
                    if isOk {
                        strongSelf.updateUI()
                    }
                })
            } else {
                guard let error = mess else { return }
                strongSelf.showAlert(with: error)
            }
        }
    }
    
    private func updateUI() {
        txtView.text = ""
        txtPhone.text = ""
        txtPrice.text = ""
        txtLocation.text = ""
        txtAcreage.text = ""
        arrImage = []
        arrImage.append(imgDefault)
        DispatchQueue.main.async {
            self.CoView.reloadData()
        }
    }
}
