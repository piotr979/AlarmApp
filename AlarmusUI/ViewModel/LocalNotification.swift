//
//  LocalNotification.swift
//  AlarmusUI
//
//  Created by Piotr Glaza on 09/12/2020.
//

import Foundation
import UIKit


class LocalNotification: ObservableObject {
    
    @Published var alarmTimer: AlarmTimer = AlarmTimer(daysLeft: 0, hoursLeft: 0, minutesLeft: 0)
    
    let userDefaults = UserDefaults.standard
    let alarmNotificationCenter = UNUserNotificationCenter.current()
    let alarmNotificationContent = UNMutableNotificationContent()
    
    init() {
        requestNotificationAuthorization()
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
           
        
    }
    func setAlarmForNotification(_ alarms: [Alarm]) ->Bool {
        guard let alarmIDWithDay = Helpers.shared.findAlarmIdForNotification(alarms: alarms) else {
            alarmTimer.alarmLeftReset()
            return false
        }
        
        // HERE WE SET ALARM ON FOR SPECIFIC HOUR/DAY IF FOUND
        if let alarm = alarms.first(where: { $0.id == alarmIDWithDay.0 }) {
            alarmTimer.hour = alarm.hour
            alarmTimer.minute = alarm.minute
            alarmTimer.daysLeft =  alarmIDWithDay.daysLeft
            alarmTimer.hoursLeft =  alarmIDWithDay.hourLeft
            alarmTimer.minutesLeft = alarmIDWithDay.minuteLeft
            sendNotification(hour: alarm.hour, minute: alarm.minute, weekday: alarmIDWithDay.1)
            
            Helpers.shared.alarmStatus = .alarmOn
            return true
        }
        alarmTimer.alarmLeftReset()
        return false
    }

func requestNotificationAuthorization() {
    alarmNotificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            print("All set!")
         
        } else if let error = error {
            print(error.localizedDescription)
        }
     
    }
}
func requestNotification(dateInfo: DateComponents) {
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
    let request = UNNotificationRequest(identifier: "Alarm", content: alarmNotificationContent, trigger: trigger)
    alarmNotificationCenter.add(request) { error in
        if let error = error {
            print("Notification issue", error.localizedDescription)
        }
    }
}
func removeNotification() {
    print("stoping all notifications...")
    alarmNotificationCenter.removeAllPendingNotificationRequests()
    alarmTimer.hour = nil
}
func sendNotification(hour: Int, minute: Int, weekday: Int) {
    let soundName:String? = SettingsVM.shared.sounds[SettingsVM.shared.selectedSound] + ".mp3"
    alarmNotificationContent.title = "Alarm"
    alarmNotificationContent.body = "Click to dismiss"
    alarmNotificationContent.badge = 3
    
    let unSound = soundName != nil ? UNNotificationSound(named: UNNotificationSoundName(soundName!)) : .default
    alarmNotificationContent.sound = unSound
    
    // if 6 means sunday, so need to converted to 1, and + 2 for any other day
    var dateInfo = DateComponents(hour: hour, minute: minute, weekday: (weekday == 6) ? 1 : (weekday + 2) )
    
    // gregorian calendar for now
    dateInfo.calendar = Calendar(identifier: .gregorian)
    
    print(dateInfo)
    requestNotification(dateInfo: dateInfo)
    }
}
