//
//  PostViewController.swift
//  NhaTro
//
//  Created by HOANGHUNG on 9/20/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
import TLPhotoPicker

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
    }
    
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
extension PostViewController:UITextViewDelegate{
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
