//
//  EditAlarmSheet.swift
//  AlarmusUI
//
//  Created by Piotr Glaza on 01/12/2020.
//

import SwiftUI

struct EditAlarmSheet: View {
    
    // MARK: - PROPERTIES
    var updateAlarmNotification: (() ->Void)?
    
    @State var alarm: Alarm
    @State var isNewAlarm = true
    @State private var selection: Date = Date()
    @State var daysSelected: [Bool] = [true,true,true,true,true,false,false]
    @EnvironmentObject var alarmVM: AlarmVM
    @Environment(\.presentationMode) var presentationMode
    
    @State var hour = 10
    @State var minutes = 10
    var days = ["M","T","W","T","F","S","S"]
    
    // MARK: - INIT
    
    init(updateLocalNotification: (()->Void)?, alarm: Alarm? = nil) {
        
        self.updateAlarmNotification = updateLocalNotification
        if let existingAlarm = alarm {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            
            let hour = Helpers.shared.formatAlarmUnitForDisplay(existingAlarm.hour)
            let minute = Helpers.shared.formatAlarmUnitForDisplay(existingAlarm.minute)
            
            let someDate = formatter.date(from: "\(hour):\(minute)")
            
            _alarm       = State(initialValue: existingAlarm)
            _isNewAlarm  = State(initialValue: false)
            _selection   = State(initialValue: someDate!)
            _hour        = State(initialValue: existingAlarm.hour)
            _minutes     = State(initialValue: existingAlarm.minute)
            _daysSelected = State(initialValue: existingAlarm.days)
            
        } else {
            let currentTime = Date()
            let calendar    = Calendar.current
            _hour           = State(initialValue:
                                        calendar.component(.hour, from: currentTime))
            _minutes        = State(initialValue:
                                        calendar.component(.minute, from: currentTime))
            
            _alarm = State(initialValue: Alarm(hour: 20, minute: 12, days: [true,true,true,true,false,false,false], isOn: false))
            print("Creating new alarm")
        }
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color.radialCenter, Color.radialEdge]), center: .center, startRadius: 10, endRadius: 500)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack {
                    HStack {
                        Text("Time")
                            .padding(.leading, 20)
                        Spacer()
                        DatePicker("", selection: $selection, displayedComponents: .hourAndMinute)
                            .datePickerStyle(
                                GraphicalDatePickerStyle())
                            .clipped()
                            .labelsHidden()
                            .frame(width: 200, height: 50)
                            .accentColor(Color.blue)
                    }
                    VStack {
                        NavigationLink(destination: DaySelectionView(daySelected: self.$daysSelected)) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Repeat alarm")
                                    .foregroundColor(.white)
                                    .padding(.bottom,3)
                                HStack {
                                    ForEach(0..<days.count) { index in
                                        Text(days[index])
                                            .foregroundColor( daysSelected[index] ? Color.accentLight :
                                                                Color.accentDark)
                                            
                                            .font(.footnote)
                                            .fontWeight(.bold)
                                    } // FOREACH
                                } // HSTACK
                            } // VSTACK
                            Spacer()
                            VStack {
                                Text(">")
                                    .foregroundColor(Color.accentLight)
                            }
                        } // NAVIGATIONLINK
                    } // VSTACK
                    .padding()
                    .background(Color.disabledDayNameColor)
                    .cornerRadius(10)
                    .padding()
                    Spacer()
                } // VSTACK
                .padding(.top, 20)
                .navigationBarTitle(Text("Edit Alarm"), displayMode: .inline)
                .navigationBarItems(leading: Button( action: {
                    
                    // --- CANCEL ACTION
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                } // LEADING BUTTON
                , trailing: Button( action: {
                    
                    // --- SAVE ACTION
                    // --- UPDATE NOTIFICATIONS
                    
                    isNewAlarm ?
                        alarmVM.addAlarm(hour: selection.currentHour, minute: selection.currentMinute, daysSelected: daysSelected) :
                        alarmVM.updateAlarm(hour: selection.currentHour, minute: selection.currentMinute, daysSelected: daysSelected, alarm: alarm)
                    self.updateAlarmNotification!()
                    // if THIS alarm is ON update localNotifiaction
                    
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                } // TRAILING BUTTON
                ) // NAV BAR ITEMS
            } // ZSTACK
            
        } // NAVIGATION VIEW
        
    }
}

struct ToggleButton: View {
    
    // MARK: - PROPERTIES
    
    @State var dayName: String
    @State var isActivated: Bool
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            Button( action: {
                isActivated.toggle()
            } ) {
                Text(dayName.uppercased())
                    .fontWeight(.bold)
                    .foregroundColor( isActivated ? Color.enabledDayNameColor : Color.disabledDayNameColor)
            } // BUTTON
            .frame(minWidth: 40)
        } // HSTACK
    }
}
