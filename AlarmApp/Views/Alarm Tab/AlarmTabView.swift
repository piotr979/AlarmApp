//
//  AlarmView.swift
//  AlarmusUI
//
//  Created by Piotr Glaza on 29/11/2020.
//

import SwiftUI

struct AlarmTabView: View {
    
    // MARK: - PROPERTIES
    
    @State var isAlarmOn: Bool = true
    @State var editAlarmSheet: Bool = false
   // @State var editAlarmShee: Bool = false
    @EnvironmentObject var localNotification: LocalNotification
    @ObservedObject var notificationCenter: NotificationCenter = NotificationCenter()
   
    @EnvironmentObject var alarmVM: AlarmVM

    // MARK: - INIT
    init() {

        UINavigationBar.appearance().barTintColor = UIColor(Color.tabBarDark)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]

    }
    
    // MARK: - BODY
  
    var body: some View {
        NavigationView {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color.radialCenter, Color.radialEdge]), center: .center, startRadius: 10, endRadius: 500)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .fullScreenCover(isPresented: $notificationCenter.isTouched, content: FullScreenModalView.init)
                // SUCH A STRANGE PLACE FOR FULLSCREENCOVER BUT DIDNT WORK IN ANY OTHER
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack {
                        VStack(spacing: 5) {
                             Text("Next alarm")
                                .font(.custom("NHaasGroteskTXPro-65Md", size: 20))
                                .foregroundColor(.white)
                            if let alarmHour = localNotification.alarmTimer.hour, let alarmMinute = localNotification.alarmTimer.minute {
                                let _ = print("Alarm is \(alarmHour)\(alarmMinute)")
                                Text("\(Helpers.shared.formatAlarmUnitForDisplay(alarmHour)):\(Helpers.shared.formatAlarmUnitForDisplay(alarmMinute))")
                                    .font(.custom("NHaasGroteskTXPro-65Md", size: 36))
                                    .foregroundColor(Color.accentLight)
                            } else {
                         Text("--:--" )
                                .font(.custom("NHaasGroteskTXPro-65Md", size: 36))
                                .foregroundColor(Color.accentLight)
                            }
                            
//                            Text("Sunday")
//                                .font(.custom("NHaasGroteskTXPro-55Rg", size: 20))
//                                .foregroundColor(.white)
                           
                            Text("in \(localNotification.alarmTimer.daysLeft) days \(localNotification.alarmTimer.hoursLeft) h \(localNotification.alarmTimer.minutesLeft) min")
                                .font(.custom("NHaasGroteskTXPro-55Rg", size: 16))
                                .foregroundColor(Color.accentLight)
                                .padding(.top,10)
                        } // VSTACK
                        .padding(.vertical,30)
                } // VSTACK
                    ForEach(alarmVM.alarms, id:\.id) { alarm in
                       AlarmItemView(alarm: alarm, updateLocalNotification: {updateLocalNotification()})
                            .padding(.horizontal)
                       } // FOREACH
                } // SCROLLVIEW
              
            } // ZSTACK
          
            .navigationTitle("Alarms")
                .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.editAlarmSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                } // TOOLBARITEM
            } // TOOLBAR
        
        } // NAVIGATION VIEW
            .navigationViewStyle(StackNavigationViewStyle())
    
        .sheet(isPresented: $editAlarmSheet, content: {
                EditAlarmSheet(updateLocalNotification: {updateLocalNotification()}).environment(\.colorScheme, .dark)
                   
        }) //: SHEET
     
        .onAppear(perform: {
          
            // --- DELETES ALL ALARMS IN CORE
            // --------------------------
            //alarmVM.deleteAllAlarms()
            print("Called")
            localNotification.setAlarmForNotification(alarmVM.alarms)
            //self.showingNotice = true
        })
} // BODY VIEW
    func updateLocalNotification() {
        print("trying")
        if isAlarmOn == true {
            print("Alarm is true")
            if Helpers.shared.alarmStatus == .alarmOn {
                localNotification.removeNotification()
                Helpers.shared.alarmStatus = .alarmOff
            }
                localNotification.setAlarmForNotification(alarmVM.alarms)
        } else {
            print("No alarm set")
            localNotification.removeNotification()
            localNotification.setAlarmForNotification(alarmVM.alarms)
          
        }
    }
}

struct FloatingNotice: View {
    @Binding var showingNotice: Bool
    var geoWidth: CGFloat
    var geoHeight: CGFloat
    @EnvironmentObject var localNotification: LocalNotification
    @State private var isAnimatingImage: Bool = false
    var body: some View {
        VStack {
            let _ = print("Showing notice")
            Text("Time left to next alarm")
                .foregroundColor(Color.black)
              Text("Days: \(localNotification.alarmTimer.daysLeft) hours: \(localNotification.alarmTimer.hoursLeft) minutes: \(localNotification.alarmTimer.minutesLeft)")
                .foregroundColor(Color.black)
        } // VSTACK
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(Color.white)
        .cornerRadius(10)
        .position(x: geoWidth / 2, y: geoHeight - 50)
        .scaleEffect(isAnimatingImage ? 1.0 : 0.6)
        .onAppear( perform: {
            withAnimation(.easeOut(duration: 0.5)) {
              isAnimatingImage = true
            }
            DispatchQueue.main.asyncAfter( deadline: .now() + 4, execute: {
                self.showingNotice = false
            }
            )
        })
    }
}

     //MARK: - PREVIEW

//struct AlarmTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlarmTabView(notificationCenter: NotificationCenter())
//            .previewDevice("iPhone 11")
//    }
//}
