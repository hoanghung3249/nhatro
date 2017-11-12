//
//  JSONFormat.swift
//  NhaTro
//
//  Created by HOANGHUNG on 11/12/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import SwiftyJSON

struct JSONFormat {
    
    var status:String
    var status_code:Int
    var message:String
    var data:JSON
    
    init(_ dataJSON:JSON) {
        status = dataJSON["status"].stringValue
        status_code = dataJSON["status_code"].intValue
        message = dataJSON["message"].stringValue
        data = dataJSON["data"]
    }
    
}
