//
//  SettingsView.swift
//  AlarmusUI
//
//  Created by Piotr Glaza on 29/11/2020.
//

import SwiftUI

struct SettingsView: View {
    
    // DUE TO ISSUES WITH USER INTERFACE IN SUBVIEWS
    // I HAD TO USE COMBINATION OF APPSTORAGE AND CLASSIC USERDEFAULTS
    // APPSTORAGE IS IN SUBVIEWS
    // HERE IS USERDEFAULTS
    
    @State private var alarmSound: Int = 1
    
   // @State private var alarmNumber: Int = 0
    //@AppStorage("soundNumber")  var soundNumber: Int = 0
    @AppStorage("increaseSound") var increaseSound: Bool = true
    @AppStorage("alarmRepeat")  var alarmRepeat: Bool = false
    @AppStorage("alarmMission") var alarmMission:Int = 0
    
    @State private var soundNumber: Int = UserDefaults.standard.integer(forKey: SettingsKeys.selectedSound.description)
    init(){
           UITableView.appearance().backgroundColor = .clear
       }
    var body: some View {
        NavigationView {
            GeometryReader { geo in
            VStack {
                ZStack {
                    RadialGradient(gradient: Gradient(colors: [Color.radialCenter, Color.radialEdge]), center: .center, startRadius: 10, endRadius: 500)
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    Form {
                        
                        Section {
                            NavigationLink(destination: SoundsListView() ) {
                                HStack {
                                    Image(systemName: "waveform")
                                    Text("Alarm sound")
                                    Spacer()
                                    Text(SettingsVM.shared.sounds[soundNumber])
                                } //: HSTACK
                            } //: NAVIGATION LINK
                            
                            Toggle(isOn: $increaseSound) {
                                Text("Increase sound gradually")
                            } //: TOGGLE
                            
                            Toggle(isOn: $alarmRepeat) {
                                Text("Alarm repeat")
                            } //: TOGGLE
                            
                            NavigationLink(destination: AlarmMissionView() ) {
                                HStack {
                                    Image(systemName: "waveform")
                                    Text("Alarm mission")
                                    Spacer()
                                    Text(SettingsVM.shared.alarmMission[alarmMission])
                                } //: HSTACK
                            } //: NAVIGATION LINK
                        } //: SECTION
                   } //: FORM
                    
                    .frame(maxWidth: geo.size.width > 700 ? geo.size.width / 1.4 : geo.size.width, alignment: .center)
                 VStack {
                        Spacer()
                        Text(" This app was created by Piotr Glaza 2021")
                            .padding(.bottom,10)
                        } //: VSTACK
                } //: ZSTACK GRADIENT
               
            } //: VSTACK
              .onAppear() {
                soundNumber = SettingsVM.shared.loadIntFromUserDefaults(SettingsKeys.selectedSound.description)
          }
            }
        } //: NAVIGATION VIEW
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    } //: BODY
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
