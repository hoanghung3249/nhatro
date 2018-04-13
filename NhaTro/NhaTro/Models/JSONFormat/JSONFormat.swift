//
//  JSONFormat.swift
//  NhaTro
//
//  Created by HOANGHUNG on 11/12/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

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

struct RegionVN {
    
    var region: String
    var lat: Double
    var long: Double
    var location: CLLocationCoordinate2D
    
    init(_ dataJSON: JSON) {
        region = dataJSON["name"].stringValue
        lat = dataJSON["lat"].doubleValue
        long = dataJSON["long"].doubleValue
        location = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
