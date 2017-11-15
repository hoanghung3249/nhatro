//
//  PostViewController.swift
//  NhaTro
//
//  Created by HOANGHUNG on 9/20/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
   
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var CoView: UICollectionView!
    @IBOutlet weak var txtAcreage: UITextField!
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        CoView.delegate = self
        CoView.dataSource = self
        txtView.delegate = self
        setupUI()
        // Do any additional setup after loading the view.
    }

    
    //MARK:- Support function
    private func setupUI() {
        self.txtLocation.contentHorizontalAlignment = .left
        self.txtPhone.contentHorizontalAlignment = .left
        self.txtPrice.contentHorizontalAlignment = .left
        self.txtAcreage.contentHorizontalAlignment = .left
        self.txtLocation.underlined(UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 0.5))
        self.txtPrice.underlined(UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 0.5))
        self.txtAcreage.underlined(UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 0.5))
        self.txtPhone.underlined(UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 0.5))
    }
}

extension PostViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        return cell
    }
}
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
