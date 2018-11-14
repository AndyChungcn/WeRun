//
//  StopWatchVC.swift
//  WeRun
//
//  Created by 钟汇杭 on 2018/11/14.
//  Copyright © 2018 钟汇杭. All rights reserved.
//

import UIKit

class StopWatchVC: UIViewController {

    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var milliSecondLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!    
    @IBOutlet weak var tableView: UITableView!
    
    var timerIsStart: Bool = false
    var minute = 0
    var second = 0
    var milliSecond = 0
    var timer = Timer()
    var roundTimers = [RoundTimer]()
    var round = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func startBtnPressed(_ sender: Any) {
        if !timerIsStart {
            timerIsStart = true
            if let image = UIImage(named: "PauseBtn") {
                startBtn.setImage(image, for: .normal)
            }
            self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        } else {
            round += 1
            timer.invalidate()
            timerIsStart = false
            if let image = UIImage(named: "StartBtn") {
                startBtn.setImage(image, for: .normal)
            }
            let roundTimer = RoundTimer(minute: minuteLabel.text!, second: secondLabel.text!, milliSecond: milliSecondLabel.text!, round: round)
            roundTimers.append(roundTimer)
            tableView.reloadData()
        }

    }
    
    @IBAction func stopBtnPressed(_ sender: Any) {
        timer.invalidate()
        second = 0
        milliSecondLabel.text = "00"
        minuteLabel.text = "00:"
        secondLabel.text = "00:"
        timerIsStart = false
        if let image = UIImage(named: "StartBtn") {
            startBtn.setImage(image, for: .normal)
        }
        round = 0
        roundTimers = []
        tableView.reloadData()
    }
    
    @objc func timerUpdate() {
        
        milliSecond += 1
        if milliSecond >= 10 {
            if milliSecond != 60 {
                milliSecondLabel.text = "\(milliSecond)"
            } else {
                milliSecondLabel.text = "00"
            }
        } else {
            milliSecondLabel.text = "0\(milliSecond)"
        }
        
        if milliSecond == 60 {
            second += 1
            if second >= 10 {
                if second != 60 {
                    secondLabel.text = "\(second):"
                } else {
                    secondLabel.text = "00:"
                }
            } else {
                secondLabel.text = "0\(second):"
            }
            milliSecond = 0
        }
        
        if second == 60 {
            minute += 1
            if minute >= 10 {
                if minute != 60 {
                    minuteLabel.text = "\(minute):"
                }
            } else {
                minuteLabel.text = "0\(minute):"
            }
            second = 0
        }
        
    }

}

extension StopWatchVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roundTimers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StopWatchTVC
        cell.timer = roundTimers.reversed()[indexPath.row]
        return cell
    }
    
}
