//
//  DefaultsStorage.swift
//  AlarmusUI
//
//  Created by start on 03/03/2021.
//

import Foundation

class DefaultsStorage {
    
    // USE THIS FOR STORING SETTINGS ONLY
    
    static let shared = DefaultsStorage()
    
    let userDefaults = UserDefaults.standard
    
    func saveSoundNumber(number: Int) {
        
        userDefaults.set(number, forKey: "soundNumber")
    }
    func loadSoundNumber() ->Int {
        let a = userDefaults.integer(forKey: "soundNumber")
        print(a)
        return a
    }
    func saveAlarmMission(index: Int) {
        userDefaults.set(index, forKey: "alarmMission")
    }
    func loadAlarmMission() ->Int {
        userDefaults.integer(forKey: "alarmMission")
    }
    func saveOtherSettings(increaseSound: Bool, soundRepeat: Bool) {
        userDefaults.set(increaseSound, forKey: "increasedSound")
        userDefaults.set(soundRepeat, forKey: "soundRepeat")
    }
    func loadOtherSettings(increaseSound: Bool, soundRepeat: Bool) {
        userDefaults.bool(forKey: "increasedSound")
        userDefaults.bool(forKey: "soundRepeat")
    }
}
