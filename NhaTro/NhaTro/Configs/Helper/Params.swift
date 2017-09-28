//
//  Params.swift
//  NhaTro
//
//  Created by HOANGHUNG on 9/25/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation


struct Params {
    
    static func createParamLogin(_ email:String,_ pass:String) -> ([String:AnyObject]?,String?) {
        var params:Dictionary<String,AnyObject> = Dictionary()
        if email.isEmptyOrWhitespace() || pass.isEmptyOrWhitespace() {
            
            return (nil, "Please input all fields requirement!")
        }
        if !email.isValidEmail() {
            
            return (nil, "The email format is invalid.")
        }
        params.updateValue(email as AnyObject, forKey: "email")
        params.updateValue(pass as AnyObject, forKey: "password")
        
        return (params,nil)
    }
    
}
