//
//  Alarm.swift
//  AlarmusUI
//
//  Created by Piotr Glaza on 30/11/2020.
//

import Foundation

struct Alarm: Identifiable {
    
    var id      = UUID()
    var hour    : Int
    var minute  : Int
    var days    : [Bool]
    var isOn    : Bool
    
}
