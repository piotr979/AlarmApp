//
//  AlarmItemView.swift
//  Alarmania (iOS)
//
//  Created by start on 14/02/2021.
//

import SwiftUI

struct AlarmItemView: View {
    
    // MARK: - PROPERTIES
    var alarm: Alarm
    var updateAlarmNotification: (() ->Void)?
    
    @State private var isAlarmOn: Bool   = false
    @State var editAlarmSheet: Bool = false
    @State private var rectState: Bool = false
    @State var accentColor = Color.accentDark
   
    
    @EnvironmentObject var alarmVM: AlarmVM
    @EnvironmentObject var localNotification: LocalNotification
    var days = ["M","T","W","T","F","S","S"]
    
    // MARK: - INIT
    
    init(alarm: Alarm, updateLocalNotification: (()->Void)?) {
        self.updateAlarmNotification = updateLocalNotification
        self.alarm = alarm
        _isAlarmOn = State(initialValue: alarm.isOn)
        
    }
    
    // MARK: - BODY
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    HStack {
                        ZStack {
                            Rectangle()
                                .fill(Color.accentDark )
                                .frame(width:15,height: 80)
                                .opacity(rectState ? 0 : 1)
                            Rectangle()
                                .fill(Color.accentLight )
                                .frame(width:15,height: 80)
                                .opacity(rectState ? 1 : 0)
                        }
                        Button( action: {
                            self.editAlarmSheet.toggle()
                            print(editAlarmSheet)
                        }) {
                            VStack(alignment: .leading) {
                                Text("\(Helpers.shared.formatAlarmUnitForDisplay(alarm.hour)):\(Helpers.shared.formatAlarmUnitForDisplay(alarm.minute))")
                                    .font(.custom("NHaasGroteskTXPro-65Md", size: 28))
                                    .foregroundColor(Color.accentLight)
                                HStack {
                                    ForEach(0..<days.count) { index in
                                        Text(days[index])
                                            .font(.footnote)
                                            .foregroundColor( alarm.days[index] ? Color.accentLight :
                                                                Color.disabledDayNameColor )
                                    } // FOREACH
                                } // HSTACK
                                .padding(.top, 5)
                            } // VSTACK
                            Spacer()
                        } // BUTTON
                        // ---------- OPENS EDIT ALARM SHEET --------------
                        .sheet(isPresented: $editAlarmSheet) {
                            EditAlarmSheet(updateLocalNotification: {updateLocalNotification()}, alarm: alarm)
                                .environment(\.colorScheme, .dark)
                        }
                        HStack {
                            Toggle("", isOn: $isAlarmOn)
                                .labelsHidden()
                                .onAppear() {
                                    if (alarm.isOn == true) {
                                        rectState = true
                                    }
                                }
                                .onChange(of: isAlarmOn, perform: { value in
                                    withAnimation(.easeIn) {
                                        if value == true {
                                            self.rectState = true
                                        } else {
                                            self.rectState = false
                                        }
                                    }
                                    alarmVM.toggleOnOff(id: alarm.id, isOn: value)
                                    updateLocalNotification()
                                })
                                .toggleStyle(SwitchToggleStyle(tint: Color.accentLight))
                            Image("more_vertical")
                                .contextMenu {
                                    
                                    // -------------------- EDIT ALARM - MICRO MENU
                                    Button {
                                        // change country setting
                                    } label: {
                                        Label("Edit alarm", systemImage: "pencil")
                                    }
                                    
                                    Button(action: {
                                        // ----------------- DELETE ALARM - MICRO MENU
                                        alarmVM.deleteAlarmByID(id: alarm.id)
                                        self.updateAlarmNotification!()
                                    }) {
                                        Label("Delete alarm", systemImage: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                        } // HSTACK
                        .padding(.trailing, 10)
                    } // HSTACK
                } // VSTACK
                    .background(Color.itemBackground)
                    .opacity(rectState ? 1 : 0.7)
                    .cornerRadius(20)
                    .frame(maxWidth: geo.size.width > 500 ? geo.size.width / 1.4 : geo.size.width, alignment: .center)
            } // ZSTACK - this extra ZStack centers items on page
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        } // GEO
        .frame(height: 80)
        .padding(.vertical, 5)
} // BODY
    
    func updateLocalNotification() {
        print("trigered")
        if isAlarmOn == true {
            if Helpers.shared.alarmStatus == .alarmOn {
                localNotification.removeNotification()
                Helpers.shared.alarmStatus = .alarmOff
            }
            localNotification.setAlarmForNotification(alarmVM.alarms)
        } else {
            localNotification.removeNotification()
            localNotification.setAlarmForNotification(alarmVM.alarms)
            
        }
    }
}

struct TestView: View {
    var body: some View {
        Text("test")
    }
}
// MARK: - PREVIEW

//struct AlarmItemView_Previews: PreviewProvider {
//    
//    var alarms =
//    static var previews: some View {
//        AlarmItemView()
//            .previewLayout(.sizeThatFits)
//    }
//}
