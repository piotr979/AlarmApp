//
//  NotificationCenter.swift
//  AlarmusUI
//
//  Created by Piotr Glaza on 09/12/2020.
//

import Foundation
import UIKit

class NotificationCenter: NSObject, ObservableObject {
    
    @Published var isTouched = false
    
    override init() {
       super.init()
        print(isTouched)
       UNUserNotificationCenter.current().delegate = self
    }
}

extension NotificationCenter: UNUserNotificationCenterDelegate  {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      
        completionHandler([.banner, .sound])
     
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        isTouched.toggle()
        print("touched in \(isTouched)")
       }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) { }
    
    // THIS FUNCTION CALLED FROM ALARMTABVIEW WORKS
    func isTouchedSetToTrue() {
        isTouched = true
}
}


