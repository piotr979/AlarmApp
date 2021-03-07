//
//  AlarmusUIApp.swift
//  AlarmusUI
//
//  Created by Piotr Glaza on 29/11/2020.
//

import SwiftUI
import UIKit
import CoreData
@main
struct AlarmusUIApp: App {
    
 
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    init() {
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
    }

    var body: some Scene {
        WindowGroup {
            AppView()
        } // WINDOWGROUP
    }
    
    // ** Implement App delegate ** //
    
//   func userNotificationCenter(
//    ) {
//       // let scene = UIApplication.shared.connectedScenes.first
//       // let sd = (scene?.delegate as? UIWindowSceneDelegate)
//       
//    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [ UIApplication.LaunchOptionsKey: Any]? = nil ) -> Bool {
        return true
    
}

// No callback in simulator
// - must use device to get valid push token

func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print(deviceToken)
}

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error ) {
    print(error.localizedDescription)
}

}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
  // This function will be called right after user tap on the notification
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      
    // tell the app that we have finished processing the user’s action / response
    completionHandler()
  }
}
