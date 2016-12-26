//
//  Timer.swift
//  Clock
//
//  Created by James Brown on 12/21/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class TimerData {
    static let shared = TimerData()
    
    private var name: String = ""
    
    func saveAlert(timer: TimerEntity? = nil) -> UIAlertController {
        var title = ""
        
        if timer != nil {
            title = "Edit Timer"
        } else {
            title = "New Timer"
        }
        
        let alertController = UIAlertController(title: title, message: "Enter timer name", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            let nameTextField = alertController.textFields![0] as UITextField
            
            if let text = nameTextField.text {
                self.name = text
                
                if let timer = timer {
                    self.save(timer: timer)
                } else {
                    self.save()
                }
            }
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Title"
            
            if let timer = timer {
                textField.text = timer.name
            }
        }
        
        return alertController
    }
    
    func save(timer: TimerEntity? = nil) {
        var item: TimerEntity!
        
        if let timer = timer {
            item = timer
        } else {
            item = TimerEntity(context: context)
            item.isRunning = false
            item.creationDate = NSDate()
        }
        
        item.name = name
        
        
        do {
            try context.save()
        } catch {
            print("Unable to save timer to core data: \(error)")
        }
    }
    
    
    func calculateTimeWhenPaused(startDate: NSDate, pauseDate: NSDate) -> Double {
        let timeSinceStartDate = Date().timeIntervalSince(startDate as Date)
        let startRef = startDate.timeIntervalSinceReferenceDate
        let pauseRef = pauseDate.timeIntervalSinceReferenceDate
        let timePaused = pauseRef - startRef
        
        return timeSinceStartDate - timePaused
    }
    
    func secondsToTimeString(seconds: Int) -> String {
        let time = (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        
        var hours = "\(time.0)"
        if time.0 < 10 {
            hours = "0\(time.0)"
        }
        
        var minutes = "\(time.1)"
        if time.1 < 10 {
            minutes = "0\(time.1)"
        }
        
        var seconds = "\(time.2)"
        if time.2 < 10 {
            seconds = "0\(time.2)"
        }
        
        return "\(hours):\(minutes):\(seconds)"
        
    }

}
























