//
//  NhaTroNavigationVC.swift
//  NhaTro
//
//  Created by HOANGHUNG on 9/20/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import UIKit

class NhaTroNavigationVC: UINavigationController {

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBasicView()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    //MARK:- Support function
    private func setupBasicView() {
        self.navigationBar.barTintColor = Color.mainColor()
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: Font.fontAvenirNextBold(20),NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    public func setupTitle(_ titleName:String) {
        self.navigationBar.topItem?.title = titleName
    }
}

// MARK: - Gesture Delegate
extension NhaTroNavigationVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
