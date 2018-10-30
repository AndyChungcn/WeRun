//
//  RealmSwift.swift
//  WeRun
//
//  Created by 钟汇杭 on 2018/10/30.
//  Copyright © 2018 钟汇杭. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConfig {
    
    static var runDataConfig: Realm.Configuration {
        let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(REALM_RUN_CONFIG)
        let config = Realm.Configuration(
            fileURL: realmPath,
            schemaVersion: 0,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 0) {
                        // Nothing to do
                        // Realm with automatically detect new properties and remove properties
                }
        })
        return config
    }
    
}
