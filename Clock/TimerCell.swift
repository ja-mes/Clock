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
    
    var timerEntity: TimerEntity!
    var timer: Timer?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        timer = TimerData().tick(with: timerEntity, to: timeLbl)
    }
    
}
