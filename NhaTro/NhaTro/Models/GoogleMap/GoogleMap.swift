//
//  GoogleMap.swift
//  NhaTro
//
//  Created by DUY on 9/21/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

class VacationDestination: NSObject {
    
    let name:String
    let location:CLLocationCoordinate2D
    let zoom:Float
    let price:String
    let phone:String
    
    init(name:String,location:CLLocationCoordinate2D,zoom:Float,price:String,phone:String) {
        self.name = name
        self.location = location
        self.zoom = zoom
        self.price = price
        self.phone = phone
    }
}
