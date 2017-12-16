//
//  RealmUtilities.swift
//  NhaTro
//
//  Created by HOANGHUNG on 12/16/17.
//  Copyright © 2017 HOANG HUNG. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmUtilities {
    
    // MARK: - Get instance realm
    static func getRealmInstanse() -> Realm {
        let defaultRealm = try! Realm()
        return defaultRealm
    }
    
    // MARK: update Realm Object
    static func updateRealmObject(updateBlock: (_ realm: Realm) -> ()) {
        
        let defaultRealm = getRealmInstanse()
        if defaultRealm.isInWriteTransaction {
            try! defaultRealm.commitWrite()
            
            defaultRealm.beginWrite()
            updateBlock(defaultRealm)
            try! defaultRealm.commitWrite()
            
            defaultRealm.beginWrite()
        }
        else {
            defaultRealm.beginWrite()
            updateBlock(defaultRealm)
            try! defaultRealm.commitWrite()
        }
    }
    
}
