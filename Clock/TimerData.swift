//
//  Timer.swift
//  Clock
//
//  Created by James Brown on 12/21/16.
//  Copyright © 2016 James Brown. All rights reserved.
//

import Foundation

class TimerData {
    private var _name: String
    
    var name: String {
        get {
            return _name
        } set {
            _name = newValue
        }
    }
    
    init(name: String) {
        _name = name
    }
    
    func save() {
        let timer = Timer(context: context)
        
        timer.startDate = NSDate()
        timer.name = name
        
        
    }
}
