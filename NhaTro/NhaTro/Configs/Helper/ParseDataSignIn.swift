//
//  ParseDataSignIn.swift
//  NhaTro
//
//  Created by HOANGHUNG on 9/27/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class ParseDataSignIn: NSObject {
    
    func fetchDataSignIn(data : JSON){
        
        let userData = User.shared
        
        userData?.email = data["email"].stringValue
        userData?.phone = data["phone"].stringValue
        userData?.address = data["address"].stringValue
        userData?.lastName = data["last_name"].stringValue
        userData?.firstName = data["first_name"].stringValue
        userData?.avatarUrl = data["avatar"].stringValue
        userData?.token = data["token"].stringValue
        userData?.active = data["active"].intValue
        userData?.total_motel = data["total_motel"].intValue
        
        
        //Save user data
        var userDataDict:[String:AnyObject] = [:]
        
        userDataDict.updateValue(userData?.email as AnyObject, forKey: "email")
        userDataDict.updateValue(userData?.phone as AnyObject, forKey: "phone")
        userDataDict.updateValue(userData?.address as AnyObject, forKey: "address")
        userDataDict.updateValue(userData?.lastName as AnyObject, forKey: "last_name")
        userDataDict.updateValue(userData?.firstName as AnyObject, forKey: "first_name")
        userDataDict.updateValue(userData?.avatarUrl as AnyObject, forKey: "avatar")
        userDataDict.updateValue(userData?.token as AnyObject, forKey: "token")
        userDataDict.updateValue(userData?.active as AnyObject, forKey: "active")
        userDataDict.updateValue(userData?.total_motel as AnyObject, forKey: "total_motel")
        dataHandle.setUserData(userDataDict)
    }
    
}
