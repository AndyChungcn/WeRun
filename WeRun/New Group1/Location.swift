//
//  Location.swift
//  WeRun
//
//  Created by 钟汇杭 on 2018/10/30.
//  Copyright © 2018 钟汇杭. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
    @objc dynamic public private(set) var latitude = 0.0
    @objc dynamic public private(set) var longitude = 0.0
    
    convenience init(latitude: Double, longitude: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
    }
}
