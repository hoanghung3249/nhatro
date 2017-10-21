//
//  CategoriesAddition.swift
//  Data Entry
//
//  Created by HOANGHUNG on 8/25/17.
//  Copyright © 2017 Apps Cyclone. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

extension String {
    func condenseWhitespace() -> String {
        return self.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: "")
    }
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
    
    var length: Int {
        return self.characters.count
    }
    
    //validate email
    func isValidEmail()-> Bool{
        //Maximum length: 254 characters
        if self.characters.count > 254 {
            return false
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return email.evaluate(with: self)
    }
    
    //validate phone number
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count && self.characters.count == 10
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    //    mutating func isValidPhoneNumber() -> Bool {
    //        if self.contains("+") {
    //            self.remove(at: self.startIndex)
    //        }
    //    }
    
    func isEmptyOrWhitespace() -> Bool {
        
        if(self.isEmpty) {
            return true
        }
        
        return (self.trimmingCharacters(in: CharacterSet.whitespaces) == "")
    }
    
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CC_SHA1((data as NSData).bytes, CC_LONG(data.count), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined(separator: "")
    }
    
    func MD5() -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        if let d = self.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
    
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height
    }
    
    
    func toDateTime(_ dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss'.'SSS") -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = dateFormat
        //Parse into NSDate
        let dateFromString : Date? = dateFormatter.date(from: self)
        
        //Return Parsed Date
        return dateFromString!
    }
    
    //    func toDateTime(dateFormat: String, timeZone : TimeZone = .local) -> Date
    //    {
    //        //Create Date Formatter
    //        let dateFormatter = DateFormatter()
    //        let zone: Foundation.TimeZone
    //        //Specify Format of String to Parse
    //        dateFormatter.dateFormat = dateFormat
    //        switch timeZone {
    //        case .local:
    //            zone = NSTimeZone.local
    //        case .utc:
    //            zone = Foundation.TimeZone(secondsFromGMT: 0)!
    //        }
    //        dateFormatter.timeZone = zone
    //        //Parse into NSDate
    //        let dateFromString : Date? = dateFormatter.date(from: self)
    //        //Return Parsed Date
    //        return dateFromString!
    //    }
    
}

extension Data {
    var hexString: String {
        return map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
    }
}



//MARK: UITABLEVIEW
extension UITableView {
    func reloadDataAnimatedKeepingOffset(){
        let offset = contentOffset
        UIView.setAnimationsEnabled(false)
        beginUpdates()
        endUpdates()
        UIView.setAnimationsEnabled(true)
        layoutIfNeeded()
        contentOffset = offset
    }
    
    func reloadAddRow(_ rowNumber: Int){
        let indexPath = IndexPath(item: rowNumber, section: 0)
        self.insertRows(at: [indexPath], with: .fade)
        self.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func reloadDeleteRow(_ rowNumber: Int){
        let indexPath = IndexPath(item: rowNumber, section: 0)
        beginUpdates()
        self.deleteRows(at: [indexPath], with: .bottom)
        endUpdates()
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.reload), userInfo: nil, repeats: false)
    }
    
    @objc func reload(){
        self.reloadData()
    }
    
    func reloadRow(_ rowNumber: Int){
        let indexPath = IndexPath(item: rowNumber, section: 0)
        self.reloadRows(at: [indexPath], with: .none)
    }
}

//MARK:- UIColor
extension UIColor {
    
    convenience init(hex: UInt32, alpha: CGFloat) {
        let red = CGFloat((hex & 0xFF0000) >> 16)/255.0
        let green = CGFloat((hex & 0xFF00) >> 8)/255.0
        let blue = CGFloat(hex & 0xFF)/255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(iRed: Int, iGreen: Int, iBlue: Int, alpha: CGFloat){
        let red = CGFloat(iRed)/255.0
        let green = CGFloat(iGreen)/255.0
        let blue = CGFloat(iBlue)/255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}

//MARK:- Textfield
extension UITextField{
    func underlined(_ color:UIColor){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }

}
