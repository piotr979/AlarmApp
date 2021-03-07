//
//  DaySelectionView.swift
//  AlarmusUI
//
//  Created by Piotr Glaza on 04/12/2020.
//

import SwiftUI

struct DaySelectionView: View {
    
    // MARK: - PROPERTIES
    
    @Binding var daySelected: [Bool]
    @EnvironmentObject var alarmVM: AlarmVM
    let textRows = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    
    // MARK: - INIT
    init(daySelected: Binding<[Bool]>) {
        self._daySelected = daySelected
        UITableView.appearance().separatorStyle = .singleLine
        
        UITableView.appearance().backgroundColor = UIColor(Color.tabBarDark)
    }
    // MARK: - BODY
    var body: some View {
        
        HStack {
            List {
                ForEach(0..<textRows.count, id:\.self) { index in
                    
                    Button(action: {
                        daySelected[index].toggle()
                        // alarmVM.updateAlarm(alarm: alarm)
                    } ) {
                        HStack {
                            Text(textRows[index])
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: daySelected[index] ? "checkmark" : "" )
                                .foregroundColor(.white)
                        } // HSTACK
                    } // BUTTON
                } // FOREACH
                .listRowBackground(Color.tabBarDark)
            } // LIST
        } // HSTACK
    }
}
// MARK: - PREVIEW`
//
//struct DaySelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        DaySelectionView(alarm: Alarm(hour: 10, minute: 20, days:
//                                        [true,true,true,true,false,false,true], isOn: true), daySelected: [$true,$true])
//    }
//}
