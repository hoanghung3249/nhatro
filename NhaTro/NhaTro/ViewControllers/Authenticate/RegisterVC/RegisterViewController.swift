//
//  RegisterViewController.swift
//  NhaTro
//
//  Created by DUY on 9/2/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit
import NKVPhonePicker

class RegisterViewController: UIViewController,SPSegmentControlDelegate,SPSegmentControlCellStyleDelegate {

    @IBOutlet weak var txtCountryCode: NKVPhonePickerTextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var segmentedControl: SPSegmentedControl!
    
        override func viewDidLoad() {
        super.viewDidLoad()

            segmentedControl?.layer.borderColor = Color.borderColor().cgColor
            segmentedControl?.backgroundColor = Color.viewBackgroundColor()
            segmentedControl?.styleDelegate = self
            segmentedControl?.delegate = self
            
            //first segment control
            let xFirstCell = self.createCell(
                text: "User",
                image: self.createImage(withName: "ionPersonStalkerIonicons")
            )
            let xSecondCell = self.createCell(
                text: "Host",
                image: self.createImage(withName: "homeAnticon")
            )
            for cell in [xFirstCell, xSecondCell] {
                cell.layout = .textWithImage
                self.segmentedControl.add(cell: cell)
            }

            

        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    private func createCell(text: String, image: UIImage) -> SPSegmentedControlCell {
        let cell = SPSegmentedControlCell.init()
        cell.label.text = text
        cell.label.font = UIFont(name: "Avenir-Medium", size: 13.0)!
        cell.imageView.image = image
        cell.imageView.contentMode = .scaleAspectFit
        cell.imageView.tintColor = .white
        return cell
    }
    
    private func createImage(withName name: String) -> UIImage {
        return UIImage.init(named: name)!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    }
    
    func selectedState(segmentControlCell: SPSegmentedControlCell, forIndex index: Int) {
        SPAnimation.animate(0.1, animations: {
            segmentControlCell.imageView.tintColor = UIColor.white
        })
        
        UIView.transition(with: segmentControlCell.label, duration: 0.1, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
            segmentControlCell.label.textColor = UIColor.white
        }, completion: nil)
    }
    
    func normalState(segmentControlCell: SPSegmentedControlCell, forIndex index: Int) {
        SPAnimation.animate(0.1, animations: {
            segmentControlCell.imageView.tintColor = UIColor.white
        })
        
        UIView.transition(with: segmentControlCell.label, duration: 0.1, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
            segmentControlCell.label.textColor = UIColor.white
        }, completion: nil)
    }
    

}





