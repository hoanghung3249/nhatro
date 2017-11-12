//
//  Constants.swift
//  NhaTro
//
//  Created by HOANGHUNG on 9/3/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import UIKit

struct Constant {
    
    struct APIKey {
        
        static let devUrl                   = "http://192.168.1.85/api"
        static let domain                   = devUrl
        
        //Authen
        static let login                    = "\(domain)/members/postLogin"
        static let logOut                   = "\(domain)/members/getLogout"
        static let register                 = "\(domain)/members/postSignup"
        static let changePass               = "\(domain)/members/change-password"
        static let forgotPass               = "\(domain)/members/forgot-password"
        static let updateProfile            = "\(domain)/motel/update-profile"
        static let sendMailAgain            = "\(domain)/motel/send-mail-again"
        static let updateRole               = "\(domain)/motel/update-roles"
        
    }
    
}


struct StatusCode {
    
    static let success                      = 200
    
}


struct Storyboard {
    
    static let main = UIStoryboard(name: "Main", bundle: nil)
    static let home = UIStoryboard(name: "Home", bundle: nil)
    
}
