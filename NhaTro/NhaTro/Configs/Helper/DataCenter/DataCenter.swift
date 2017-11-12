//
//  DataCenter.swift
//  NhaTro
//
//  Created by HOANGHUNG on 11/5/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class DataCenter {
    
    static let shared = DataCenter()
    
    func callAPIUpdateRole(_ token:String, _ completion:((_ success:Bool, _ mess:String?) -> Void)?) {
        NetworkService.requestWithHeader(.get, token, url: Constant.APIKey.updateRole, parameters: nil) { (data, mess, code) in
            guard let completion = completion else { return }
            guard let code = code else { return }
            if code == StatusCode.success {
                completion(true, nil)
            } else {
                guard let error = mess else { return }
                completion(false, error)
            }
        }
    }
    
    func callAPILogOut(_ token:String,  _ completion:((_ success:Bool, _ mess:String?) -> Void)?) {
        NetworkService.requestWithHeader(.get, token, url: Constant.APIKey.logOut, parameters: nil) { (data, error, code) in
            guard let completion = completion else { return }
            if error != nil {
                if let code = code {
                    if code == StatusCode.success {
                        USER?.logOut()
                        URLCache.shared.removeAllCachedResponses()
                        URLCache.shared.diskCapacity = 0
                        URLCache.shared.memoryCapacity = 0
                        completion(true, nil)
                    } else {
                        guard let err = error else { return }
                        completion(false, err)
                    }
                }
            }
        }
    }
    
    func callAPIEditProfile(_ param:[String:Any], _ imageName:String, _ imageProfile:[UIImage], _ completion:((_ success:Bool, _ mess:String?) -> Void)?) {
        guard let userToken = USER?.token else { return }
        let _headers: HTTPHeaders = ["Accept": "application/json",
                                     "Authorization": "Bearer \(userToken)"
        ]
        NetworkService.callApiMultiPart(url: Constant.APIKey.updateProfile, withNames: [imageName], method: .post, images: imageProfile, parameters: param, headers: _headers, completion: { (data) in
            guard let completion = completion else { return }
            let jsonFormat = JSONFormat(data)
            let parser:ParseDataSignIn = ParseDataSignIn()
            if jsonFormat.status == "success" {
                let userData = jsonFormat.data
                print(userData)
                parser.fetchDataSignIn(data: userData)
                completion(true, jsonFormat.message)
            } else {
                completion(false, jsonFormat.message)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }    
}
