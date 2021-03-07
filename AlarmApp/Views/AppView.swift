//
//  ContentView.swift
//  AlarmusUI
//
//  Created by Piotr Glaza on 29/11/2020.
//

import SwiftUI

struct AppView: View {
    
   
    // MARK: - PROPERTIES
   
    var alarmVM = AlarmVM()
    var localNotification = LocalNotification()
   
    
    @StateObject var notificationCenter = NotificationCenter()
    
    // MARK: - INIT
    
    init() {
        UITabBar.appearance().barTintColor = UIColor(Color.tabBarDark)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.disabledDayNameColor)
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageURL = documents.appendingPathComponent("tempImage_wb.jpg")
        print("Documents directory:", imageURL.path)
    }
    
    // MARK: - VIEW
    
    var body: some View {
        
        TabView {
            AlarmTabView()
                .environmentObject(alarmVM)
                .environmentObject(notificationCenter)
                .environmentObject(localNotification)
                .tabItem {
                    Image(systemName: "alarm")
                    Text("Alarms")
                } //: TABITEM
                
            SettingsView()
                .environment(\.colorScheme, .dark)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                        
                } //: TABITEM
        } // TABVIEW
        .accentColor(.white)
    }
}
