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
    
    static let GoogleAPIKey = "AIzaSyDoEM53gYja9D3Gjou5nMsWe1MiDbkBHww"
    static let googleDirectionKey = "AIzaSyBxbJblSeYPL_b4RghEhzQV47-mRq0Sfno"
    static let googleURLDirection = "https://maps.googleapis.com/maps/api/directions/json"
    
    struct APIKey {
        
        static let devUrl                   = "http://192.168.1.45/api"
        static let baseUrl                  = "http://192.168.1.45/"
        static let domain                   = devUrl
        static let secretKey                = "DEVNATSVSMOTEL01031995"
        
        //Authen
        static let login                    = "\(domain)/members/postLogin"
        static let logOut                   = "\(domain)/members/getLogout"
        static let register                 = "\(domain)/members/postSignup"
        static let changePass               = "\(domain)/members/change-password"
        static let forgotPass               = "\(domain)/members/forgot-password"
        static let updateProfile            = "\(domain)/motel/update-profile"
        static let sendMailAgain            = "\(domain)/motel/send-mail-again"
        static let updateRole               = "\(domain)/motel/update-roles"
        
        //Motel
        static let getListMotel             = "\(domain)/motel/get-news"
        static let getListFilter            = "\(domain)/motel/filter-motel"
        static let postMotel                = "\(domain)/motel/post-news"
    }
    
}


struct StatusCode {
    
    static let success                      = 200
    
}

struct ErrorMessage {
    
    static let cannotConnect                = "Could not connect to the server."
    static let cannotConnectVN              = "Đã xảy ra lỗi, xin hãy thử lại!"
    
}


struct Storyboard {
    
    static let main = UIStoryboard(name: "Main", bundle: nil)
    static let home = UIStoryboard(name: "Home", bundle: nil)
    static let detail = UIStoryboard(name: "DetailHostel", bundle: nil)
}
