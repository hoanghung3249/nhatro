//
//  Color.swift
//  NhaTro
//
//  Created by DUY on 9/2/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import UIKit

class Color {
    
    static func borderColor() -> UIColor {
        return UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 0.8)
    }
    
    static func viewBackgroundColor() -> UIColor{
        return UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 0.8)
    }
    
    static func mainColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 173.0/255.0, blue: 14.0/255.0, alpha: 0.7)
    }
    
    static func kLightGrayColor() -> UIColor {
        return UIColor(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1)
    }
    
    static func kGrayColor() -> UIColor {
        return UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1)
    }


    
}

class Font: UIFont {
    
    static func fontAvenirNext(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir Next", size: size)!
    }
    
    static func fontAvenirNextBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Bold", size: size)!
    }
}
