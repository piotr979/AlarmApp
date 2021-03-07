//
//  AlarmTimer.swift
//  AlarmusUI
//
//  Created by Piotr Glaza on 27/12/2020.
//

import Foundation

struct AlarmTimer {
    
    var hour: Int?
    var minute: Int?
    var daysLeft: Int = 0
    var hoursLeft: Int = 0
    var minutesLeft: Int = 0
    
    
    mutating func alarmLeftReset() {
        self.daysLeft = 0
        self.hoursLeft = 0
        self.minutesLeft = 0
    }
}
