//
//  NetworkReachability.swift
//  NhaTro
//
//  Created by HOANGHUNG on 12/9/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import Alamofire

class NetworkReachability {
    
    // Check if device has internet connection or not
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
}
