//
//  SettingsVM.swift
//  AlarmusUI
//
//  Created by start on 07/03/2021.
//

import Foundation

enum SettingsKeys: CustomStringConvertible {
    case selectedSound
    case selectedMission
    
    var description: String {
        switch self {
        case .selectedSound: return "selectedAlarmSound"
        case .selectedMission: return "selectedAlarmMission"
        }
    }
}
class SettingsVM {
    
    let sounds = ["Analog watch","Fire alarm","Foghorn","School bell"]
    let alarmMission = ["None", "Math task"]
    var selectedSound = 0
    var selectedMission = 0
    var increaseVolume: Bool = false
    var alarmRepeat: Bool = false
    
    static let shared = SettingsVM()
    
    init() {
        selectedSound = loadIntFromUserDefaults(SettingsKeys.selectedSound.description)
        selectedMission = loadIntFromUserDefaults(SettingsKeys.selectedMission.description)
        
    }
    func loadIntFromUserDefaults(_ forKey: String) ->Int {
        return UserDefaults.standard.integer(forKey: forKey)
    }
    func saveIntToUserDefaults(value: Int, _ forKey: String) {
        UserDefaults.standard.setValue(value, forKey: forKey)
    }
}
