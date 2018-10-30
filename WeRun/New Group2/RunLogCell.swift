//
//  RunLogCell.swift
//  WeRun
//
//  Created by 钟汇杭 on 2018/10/29.
//  Copyright © 2018 钟汇杭. All rights reserved.
//

import UIKit

class RunLogCell: UITableViewCell {

    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(run: Run) {
        
    }

}
