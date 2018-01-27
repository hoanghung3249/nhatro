//
//  MotelRealm.swift
//  NhaTro
//
//  Created by HOANGHUNG on 1/6/18.
//  Copyright © 2018 HOANG HUNG. All rights reserved.
//

import Foundation
import RealmSwift

class RealmString: Object {
    @objc dynamic var stringValue = ""
}

class MotelRealm: Object {
    
    @objc dynamic var motel_Id: Int = 0
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var avatar: String?
    @objc dynamic var name: String?
    @objc dynamic var des: String?
    @objc dynamic var location: String?
    @objc dynamic var phone: String?
    @objc dynamic var unit_price: String?
    @objc dynamic var promotion_price: String?
    @objc dynamic var area: String?
    let latitude = RealmOptional<Double>()
    let longitude = RealmOptional<Double>()
    @objc dynamic var createdAt: String?
    let arrImage = List<RealmString>()
    let images = List<MotelImageRealm>()
//    var internalArrImg = [String]()
    
    override static func primaryKey() -> String? {
        return "motel_Id"
    }
    
    func addOrUpdate(_ realm: Realm, motel: Motel) {
        var values: [String: Any?] = [
            "motel_Id": motel.motel_Id,
            "name": motel.name,
            "firstName": motel.firstName,
            "lastName": motel.lastName,
            "avatar": motel.avatar,
            "des": motel.description,
            "location": motel.location,
            "phone": motel.phone,
            "unit_price": motel.unit_price,
            "promotion_price": motel.promotion_price,
            "area": motel.area,
            "latitude": motel.latitude,
            "longitude": motel.longitude,
            "createdAt": motel.createdAt,
        ]

        if motel.images.count > 0 {
            motel.images.forEach({ (image) in
                let imageRealm = MotelImageRealm()
                imageRealm.sub_image = image.sub_image
                imageRealm.sub_image_thumb = image.sub_image_thumb
                images.append(imageRealm)
            })
        }
        values["images"] = images
        values["imageName"] = arrImage

        realm.create(MotelRealm.self, value: values, update: true)
    }
    
}
