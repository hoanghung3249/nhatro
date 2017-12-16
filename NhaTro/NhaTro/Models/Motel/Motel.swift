//
//  Motel.swift
//  NhaTro
//
//  Created by HOANGHUNG on 11/19/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Motel {
    var firstName:String
    var lastName:String
    var avatar:String
    var name:String
    var description:String
    var location:String
    var motel_Id:Int
    var phone:String
    var unit_price:Double
    var promotion_price:Double
    var area:Double
    var latitude:Double
    var longitude:Double
    var images = [MotelImage]()
    var createdAt:String
    
    init(_ dataJSON:JSON) {
        name = dataJSON["name"].stringValue
        description = dataJSON["description"].stringValue
        motel_Id = dataJSON["id"].intValue
        phone = dataJSON["phone"].stringValue
        unit_price = dataJSON["unit_price"].doubleValue
        promotion_price = dataJSON["promotion_price"].doubleValue
        area = dataJSON["erea"].doubleValue
        latitude = dataJSON["latitude"].doubleValue
        longitude = dataJSON["longitude"].doubleValue
        location = dataJSON["location"].stringValue
        firstName = dataJSON["first_name"].stringValue
        lastName = dataJSON["last_name"].stringValue
        avatar = dataJSON["avatar"].stringValue
        createdAt = dataJSON["created_at"].stringValue
        if let arrImage = dataJSON["image"].array {
            if arrImage.count > 0 {
                for img in arrImage {
                    let image = MotelImage(img)
                    images.append(image)
                }
            }
        }
    }
}

struct MotelImage {
    var sub_image:String
    var sub_image_thumb:String
    
    init(_ dataJSON:JSON) {
        sub_image = dataJSON["sub_image"].stringValue
        sub_image_thumb = dataJSON["sub_image_thumb"].stringValue
    }
}
