//
//  Timer.swift
//  Clock
//
//  Created by James Brown on 12/21/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class TimerData {
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
    
}
























