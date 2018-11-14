//
//  StopWatchTVC.swift
//  WeRun
//
//  Created by 钟汇杭 on 2018/11/14.
//  Copyright © 2018 钟汇杭. All rights reserved.
//

import UIKit

class StopWatchTVC: UITableViewCell {

    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var roundTime: UILabel!
    
    var timer: RoundTimer? {
        didSet {
            configureCell()
        }
    }
    
    func configureCell() {
        roundTime.text = timer?.roundText
        roundLabel.text = timer?.round
    }

}
