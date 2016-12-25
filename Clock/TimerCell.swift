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

    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        timerEntity.isRunning = false
        appDel.saveContext()
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        timerEntity.isRunning = true
        timerEntity.startDate = NSDate()
        appDel.saveContext()
    }
}
