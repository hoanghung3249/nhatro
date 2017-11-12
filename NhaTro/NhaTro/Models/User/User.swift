//
//  User.swift
//  NhaTro
//
//  Created by HOANGHUNG on 9/27/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import SwiftyJSON

internal let USER = User.shared

class User {
    
    static let shared: User! = User()
    
    var email:String!
    var token:String!
    var address:String!
    var phone:String!
    var avatarUrl:String!
    var active:Int!
    var total_motel:Int!
    var firstName:String!
    var lastName:String!
    var roleId:Int!
    var latitude:String!
    var longitude:String!
    
    //Xóa value về giá trị mặc định
    internal func logOut() {
        self.email = ""
        self.token = ""
        self.address = ""
        self.phone = ""
        self.avatarUrl = ""
        self.active = -1
        self.total_motel = -1
        self.firstName = ""
        self.lastName = ""
        self.roleId = 0
        self.latitude = ""
        self.longitude = ""
        dataHandle.removeUserData()
    }
    
    
    func parseUserData(_ userDict: [String:AnyObject]?) {
        if let user = userDict {
            self.firstName = user["first_name"] as! String
            self.lastName = user["last_name"] as! String
            self.phone = user["phone"] as! String
            self.email = user["email"] as! String
            self.address = user["address"] as? String ?? ""
            self.active = user["active"] as! Int
            self.total_motel = user["total_motel"] as! Int
            self.avatarUrl = user["avatar"] as? String ?? ""
            self.token = user["token"] as! String
            self.roleId = user["role_id"] as? Int
            self.latitude = user["latitude"] as? String ?? ""
            self.longitude = user["longitude"] as? String ?? ""
        } else {
            self.email = ""
            self.token = ""
            self.address = ""
            self.phone = ""
            self.avatarUrl = ""
            self.active = -1
            self.total_motel = -1
            self.firstName = ""
            self.lastName = ""
            self.roleId = 0
            self.latitude = ""
            self.longitude = "0.0"
        }
    }
}

