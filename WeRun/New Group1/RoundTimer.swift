//
//  Timer.swift
//  WeRun
//
//  Created by 钟汇杭 on 2018/11/14.
//  Copyright © 2018 钟汇杭. All rights reserved.
//

import Foundation

struct RoundTimer {
    
    var minute: String
    var second: String
    var milliSecond: String
    var roundText: String
    var round: String
    
    init(minute: String, second: String, milliSecond: String, round: Int) {
        self.minute = minute
        self.second = second
        self.milliSecond = milliSecond
        self.roundText = minute + second + milliSecond
        self.round = "第\(round)回合"
    }
    
}
