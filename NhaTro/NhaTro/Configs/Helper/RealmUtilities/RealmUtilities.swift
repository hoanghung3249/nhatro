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
    
    // MARK: - Init Realm
    static func initRealm(_ version: UInt64, migrate block: MigrationBlock?) {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: version, migrationBlock: block)
    }
    
    // MARK: - Get instance realm
    static func getRealmInstanse() -> Realm {
        let defaultRealm = try! Realm()
        return defaultRealm
    }
    
    // MARK: - Update Realm Object
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
