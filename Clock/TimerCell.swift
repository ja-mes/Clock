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

    override func awakeFromNib() {
        super.awakeFromNib()
        
        var counter = 0
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            counter += 1
            self.timeLbl.text = "\(counter)"
        }
    }
    
}
