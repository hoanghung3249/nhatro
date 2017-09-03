//
//  CategoriesAddition.swift
//  Data Entry
//
//  Created by HOANGHUNG on 8/25/17.
//  Copyright © 2017 Apps Cyclone. All rights reserved.
//

import Foundation
import UIKit

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
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
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
    
    func reload(){
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
extension UITextField{
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }

}
