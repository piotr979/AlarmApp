//
//  Date.swift
//  AlarmusUI
//
//  Created by Piotr Glaza on 12/12/2020.
//

import Foundation

extension Date {
    
    var day: Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        
        // Gregorian calendar:
        // Sunday is 1
        // Monday is 2
        // Saturday is 7
        // Weekday return from 1-7 (Sunday is 1st)
    
        // if sunday return 6 (sunday is last).
        return (weekday == 1) ? 6 : (weekday - 2)
        
    }
    var currentHour: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return Int(formatter.string(from: self))!
    }
    var currentMinute: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return Int(formatter.string(from: self))!
    }
}
