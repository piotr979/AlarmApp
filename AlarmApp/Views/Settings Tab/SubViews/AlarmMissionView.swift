//
//  AlarmMissionView.swift
//  AlarmusUI
//
//  Created by start on 28/02/2021.
//

import SwiftUI

struct AlarmMissionView: View {
    
    // MARK: - PROPERTIES
    
    //@AppStorage("alarmMission") var alarmMission: Int = 0
    @State var selectedRow: Int
    
    init() {
        _selectedRow = State(initialValue: UserDefaults.standard.integer(forKey: "alarmMission"))
    }
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [Color.radialCenter, Color.radialEdge]), center: .center, startRadius: 10, endRadius: 500)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            List {
                ForEach(0..<SettingsVM.shared.alarmMission.count, id:\.self) { index in
                    Button( action: {
                        DefaultsStorage.shared.saveAlarmMission(index: index)
                        selectedRow = index
                    }) {
                        HStack {
                            Text(SettingsVM.shared.alarmMission[index])
                            Spacer()
                            Image( systemName: selectedRow == index ? "checkmark" : "" )
                        } //: HSTACK
                    } //: BUTTON
                    .listRowBackground( selectedRow == index ? Color.accentDark : Color.radialEdge)
                } //: FOREACH
            } //: LIST
        } //: ZSTACK
    }
}

struct AlarmMissionView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmMissionView()
    }
}
