//
//  Params.swift
//  NhaTro
//
//  Created by HOANGHUNG on 9/25/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation


struct Params {
    
    static func createParamLogin(_ email:String,_ pass:String,_ completion:(_ error:String?,_ params:[String:AnyObject]?)->()) {
        var params:Dictionary<String,AnyObject> = Dictionary()
        if email.isEmptyOrWhitespace() || pass.isEmptyOrWhitespace() {
            completion("Please input Email or Password!", nil)
            return
        }
        if !email.isValidEmail() {
            completion("Email Address in invalid format!", nil)
            return
        }
        params.updateValue(email as AnyObject, forKey: "email")
        params.updateValue(pass as AnyObject, forKey: "password")
        completion(nil, params)
        return
    }
    
}
