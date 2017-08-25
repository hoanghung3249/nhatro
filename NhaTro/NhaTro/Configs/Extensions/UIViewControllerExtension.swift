//
//  UIViewControllerExtension.swift
//  Data Entry
//
//  Created by HOANGHUNG on 8/25/17.
//  Copyright © 2017 Apps Cyclone. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    
    func showAlert(with messages: String) {
        let alert = UIAlertController(title: "ERROR", message: messages, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertSuccess(with messages: String) {
        let alert = UIAlertController(title: "MESSAGE", message: messages, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - PRESENT VC
    func addChildView(_ storyboardName: String, identifier: String) -> UIViewController{
        let vc = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier)
        self.addChildViewController(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        return vc
    }
    
    func pushTo(_ vc: UIViewController){
        let transition = TransitionManager.sharedInstance
        transition.isPresentOnBackButton = false
        vc.transitioningDelegate = transition
        self.present(vc, animated: true, completion: nil)
    }
    
    func popFrom(_ vc: UIViewController){
        let transition = TransitionManager.sharedInstance
        transition.isPresentOnBackButton = true
        vc.transitioningDelegate = transition
        self.present(vc, animated: true, completion: nil)
    }
    
    func rootVC() -> UIViewController{
        return UIApplication.shared.keyWindow!.rootViewController!
    }
    
    //MARK: - HIDE KEYBOARD
    
    func tapToHideKeyboard(){
        let tapOutside = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        self.view.addGestureRecognizer(tapOutside)
    }
    
    func tap(_ gesture: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
}
