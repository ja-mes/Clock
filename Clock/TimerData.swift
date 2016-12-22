//
//  Timer.swift
//  Clock
//
//  Created by James Brown on 12/21/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import UIKit

class TimerData {
    
    func saveAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "New Timer", message: "Enter timer name", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            let nameTextField = alertController.textFields![0] as UITextField
            
            if let text = nameTextField.text {
                self.save(name: text)
            }
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        
        return alertController
    }
    
    func save(name: String) {
        let timer = Timer(context: context)
        
        timer.startDate = NSDate()
        timer.name = name
        
        do {
            try context.save()
        } catch {
            print("Unable to save timer to core data: \(error)")
        }
    }
}
