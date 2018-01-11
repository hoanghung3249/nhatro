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
    var internalArrImg = [String]()
    
    override static func primaryKey() -> String? {
        return "motel_Id"
    }
    
    func addOrUpdate(_ realm: Realm) {
        var values: [String: Any?] = [
            "motel_Id": motel_Id,
            "name": name,
            "firstName": firstName,
            "lastName": lastName,
            "avatar": avatar,
            "des": des,
            "location": location,
            "phone": phone,
            "unit_price": unit_price,
            "promotion_price": promotion_price,
            "area": area,
            "latitude": latitude.value,
            "longitude": longitude.value,
            "createdAt": createdAt,
        ]
        if internalArrImg.count > 0 {
            internalArrImg.forEach({ (img) in
                let realmString = RealmString()
                realmString.stringValue = img
                arrImage.append(realmString)
            })
            values["arrImage"] = arrImage
        }
        values["arrImage"] = arrImage
        
        realm.create(MotelRealm.self, value: values, update: true)
    }
    
}