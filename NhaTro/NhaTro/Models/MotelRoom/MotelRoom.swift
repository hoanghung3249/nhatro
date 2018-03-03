//
//  MotelRoom.swift
//  NhaTro
//
//  Created by HOANGHUNG on 2/21/18.
//  Copyright © 2018 HOANG HUNG. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MotelRoom {
    var id: Int
    var name: String
    // 0 not available - 1 available
    var status: Int
    var isAvailable: Bool
    var unit_price: String
    var area: String
    
    init(_ json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        status = json["status"].intValue
        if status == 1 {
            isAvailable = true
        } else {
            isAvailable = false
        }
        unit_price = json["unit_price"].stringValue
        area = json["erea"].stringValue
    }
}
