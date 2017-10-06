//
//  ChangePassViewController.swift
//  NhaTro
//
//  Created by HOANGHUNG on 10/6/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class ChangePassViewController: UIViewController {

    @IBOutlet weak var txtOldPass: UITextField!
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
    }
    
    func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }

}
