//
//  DataHandle.swift
//  NhaTro
//
//  Created by HOANGHUNG on 9/27/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation

internal let dataHandle = DataHandle.shared
class DataHandle: NSObject {
    
    static let shared : DataHandle = DataHandle()
    
    //Lưu user
    func setUserData(_ userLoginDict: [String: AnyObject]){
        let userDefault = UserDefaults.standard
        //Kiểm tra nếu user đã tồn tại thì xóa data cũ
        if userDefault.value(forKey: "setUserData") != nil{
            userDefault.removeObject(forKey: "setUserData")
        }
        let userData = NSKeyedArchiver.archivedData(withRootObject: userLoginDict)
        userDefault.set(userData, forKey: "setUserData")
        userDefault.synchronize()
    }
    
    func removeUserData(){
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: "setUserData")
        userDefault.synchronize()
    }
    
    //Lấy data user theo Dictionary
    func getUserData() -> [String: AnyObject]?{
        let userDefault = UserDefaults.standard
        if let userData = userDefault.value(forKey: "setUserData") as? Data{
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: userData) as? [String: AnyObject]
            USER?.parseUserData(userInfo!)
            return userInfo
        }
        return nil
    }
    
}
