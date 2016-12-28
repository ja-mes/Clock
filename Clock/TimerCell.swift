//
//  TimerCell.swift
//  Clock
//
//  Created by James Brown on 12/21/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class TimerCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var timerEntity: TimerEntity!
    var timer: Timer?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            startButton.isHidden = true
        } else {
            startButton.isHidden = false
        }
    }

    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        if timerEntity.isRunning {
            timerEntity.isRunning = false
            
            sender.backgroundColor = #colorLiteral(red: 0, green: 0.6969566941, blue: 0.2550100088, alpha: 1)
            sender.setTitle("Start", for: .normal)
        } else {
            timerEntity.isRunning = true
            
//            if let startDate = timerEntity.startDate, let pauseDate = timerEntity.pauseDate {
//                let secondsOnTimer = Int(TimerData.shared.calculateTimeWhenPaused(startDate: startDate, pauseDate: pauseDate).rounded())
//                
//                if let date = Calendar.current.date(byAdding: .second, value: -secondsOnTimer, to: Date()) {
//                    timerEntity.startDate = date as NSDate
//                }
//            } else {
//                timerEntity.startDate = NSDate()
//            }
//            
            
            timerEntity.startDate = NSDate()
            
            sender.backgroundColor = #colorLiteral(red: 1, green: 0.1535346806, blue: 0.1441769302, alpha: 1)
            sender.setTitle("Stop", for: .normal)
        }
        
        appDel.saveContext()

    }
}
