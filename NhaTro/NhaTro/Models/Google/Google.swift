//
//  Google.swift
//  NhaTro
//
//  Created by DUY on 9/8/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import GoogleSignIn
import SwiftyJSON

struct Google {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
    }

}
