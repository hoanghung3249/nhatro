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
    
    static func createParamResgister(_ email:String,_ pass:String,_ phone:String,_ firstName:String,_ lastName:String,_ confirmPass:String) -> ([String:AnyObject]?,String?) {
        var params:Dictionary<String,AnyObject> = Dictionary()
        if email.isEmptyOrWhitespace() || pass.isEmptyOrWhitespace() || phone.isEmptyOrWhitespace() || firstName.isEmptyOrWhitespace() ||  lastName.isEmptyOrWhitespace() || confirmPass.isEmptyOrWhitespace()  {
            
            return (nil, "Please input all fields requirement!")
        }
        if !email.isValidEmail() {
            
            return (nil, "The email format is invalid.")
        }
        if confirmPass != pass {
            return(nil , "The confirm password does not correct with the password! ")
        }
        if pass.characters.count < 6 {
            return(nil,"The password has contains at least 6 character!")
        }
        params.updateValue(email as AnyObject, forKey: "email")
        params.updateValue(pass as AnyObject, forKey: "password")
        params.updateValue(phone as AnyObject, forKey: "phone")
        params.updateValue(lastName as AnyObject, forKey: "last_name")
        params.updateValue(firstName as AnyObject, forKey: "first_name")
        return (params,nil)
    }

    static func createParamChangePass(_ newPass:String,_ confirmPass:String) -> ([String:AnyObject]?,String?) {
        var params:Dictionary<String,AnyObject> = Dictionary()
        
        if newPass.isEmptyOrWhitespace() || confirmPass.isEmptyOrWhitespace() {
            return (nil, "Please input all fields requirement!")
        }
        
        if confirmPass != newPass {
            return(nil , "The confirm password does not correct with the password! ")
        }
        params.updateValue(newPass as AnyObject, forKey: "password")
        return(params,nil)
    }
    
    
}
