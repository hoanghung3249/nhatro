//
//  Extensions.swift
//  NhaTro
//
//  Created by HOANGHUNG on 3/29/18.
//  Copyright © 2018 HOANG HUNG. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UserDefaults extension
extension UserDefaults {
    internal static func setValue(_ value: Any?, forKey key: DefaultValueKeys) {
        self.standard.set(value, forKey: key.rawValue)
    }
    
    internal static func double(forKey key: DefaultValueKeys) -> Double {
        return self.standard.double(forKey: key.rawValue)
    }
    
    internal static func integer(forKey key: DefaultValueKeys) -> Int {
        return self.standard.integer(forKey: key.rawValue)
    }
    
    internal static func bool(forKey key: DefaultValueKeys) -> Bool {
        return self.standard.bool(forKey: key.rawValue)
    }
    
    internal static func string(forKey key: DefaultValueKeys) -> String? {
        return self.standard.string(forKey: key.rawValue)
    }
}

// MARK: - Extension Navigation
extension UINavigationController {
    //Same function as "popViewController", but allow us to know when this function ends
    func popViewControllerWithHandler(completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: true)
        CATransaction.commit()
    }
    func pushViewController(viewController: UIViewController, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
}
