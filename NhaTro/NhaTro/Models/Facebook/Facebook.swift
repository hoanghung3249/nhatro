//
//  Facebook.swift
//  NhaTro
//
//  Created by DUY on 9/8/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import SwiftyJSON

struct Facebook {

    static func loginWithFacebook(viewcontroller:UIViewController ,_ Success: @escaping success, _ Failed: @escaping failed) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: viewcontroller) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.isCancelled {
                    Failed("Cancel", 1)
                } else {
                    if fbloginresult.grantedPermissions != nil {
                        if(fbloginresult.grantedPermissions.contains("email")) {
                            if((FBSDKAccessToken.current()) != nil){
                                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                                    if (error == nil){
                                        if let result = result as? Dictionary<String,Any> {
                                            Success(result)
                                        }
                                    } else {
                                        Failed((error?.localizedDescription)!, nil)
                                    }
                                })
                            }
                        }
                    }
                }
            } else {
                Failed((error?.localizedDescription)!,nil)
            }
        }
    }
}
