//
//  DataCenter.swift
//  NhaTro
//
//  Created by HOANGHUNG on 11/5/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import SwiftyJSON

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
}