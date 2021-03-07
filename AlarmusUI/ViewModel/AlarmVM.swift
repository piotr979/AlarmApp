//
//  AlarmVM.swift
//  AlarmusUI
//
//  Created by Piotr Glaza on 21/01/2021.
//

import Foundation
import CoreData
protocol AlarmVMProtocol {
    
    func deleteAlarm(index: IndexSet)
    func addAlarm(hour: Int, minute: Int, daysSelected: [Bool])
    func updateAlarm(hour: Int, minute: Int, daysSelected: [Bool], alarm: Alarm)
    func toggleOnOff(id: UUID, isOn: Bool)
    
}
    
    class AlarmVM: ObservableObject {
        let context = CoreDataPersistence.shared.persitentContainer.viewContext
        @Published var alarms: [Alarm] = []
        
        init() {
            getAlarmCoreData()
        }
    }


extension AlarmVM: AlarmVMProtocol {
    
    func deleteAlarm(index: IndexSet) {
        let indexes = index.map { $0 }
        let firstIndex = indexes.first
        print(alarms[firstIndex!].id)
        alarms.remove(at: firstIndex!)
        // grab the id of first indexed alarm
        // indexes[0].id
    }
    func deleteAllAlarms() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AlarmData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("cannot delete all entries")
        }
    }
    func getAlarmCoreData() {
       
        let fetchRequest: NSFetchRequest<AlarmData> = AlarmData.fetchRequest()
            do {
               try context.count(for: fetchRequest)
                } catch {
                    return
                }
            do {
                let result = try context.fetch(fetchRequest)
                for item in result {
                    let id = item.id
                    let hour = Int(item.hour)
                    let minute = Int(item.minute)
                    let days: [Bool] = item.days
                    let isOn = item.isOn
                    let alarm = Alarm(id: id!, hour: hour, minute: minute, days: days, isOn: isOn)
                    alarms.append(alarm)
                }
            } catch {
                debugPrint(error)
            }
    }
    func addAlarmCoreData(alarm: Alarm) {
        let alarmData = AlarmData(context: self.context)
        alarmData.id = alarm.id
        print("id alarmu przy dodowaniu to \(alarm.id)")
        alarmData.hour = Int16(alarm.hour)
        alarmData.minute = Int16(alarm.minute)
        alarmData.isOn = alarm.isOn
        alarmData.days = alarm.days
        saveCoreData()
    }
    func saveCoreData() {
        
     //   let alarms = AlarmData(context: context)
        
        do {
            try context.save()
            print("Ssaved")
            
        } catch {
            print("There was an error")
        }
    }

    func deleteAlarmByID(id: UUID) {
        let index = getIndexOfAlarm(id: id)
        if let alarmIndex = index {
        alarms.remove(at: alarmIndex)
        deleteAlarmByIdCoreData(id: id)
        }
    }
    func deleteAlarmByIdCoreData(id: UUID) ->Bool {
        let fetchRequest: NSFetchRequest<AlarmData> = AlarmData.fetchRequest()
       
        do {
            let result = try context.fetch(fetchRequest)
            for item in result {
                if item.id == id {
                    context.delete(item)
                    saveCoreData()
                    return true
                }
            }
        } catch let error {
            print("Cannot fetch data to delete \(error)")
        }
        return false
    }
    func addAlarm(hour: Int, minute: Int, daysSelected: [Bool]) {
        print("adding new \(hour) and \(minute)")
        let alarm = Alarm(hour: hour, minute: minute, days: daysSelected, isOn: true)
        alarms.append(alarm)
        addAlarmCoreData(alarm: alarm)
        print(alarms)
    }
    
    func updateAlarm(hour: Int, minute: Int, daysSelected: [Bool], alarm: Alarm) {
        
       
        // find exisiing alarm
        //and delete
        if !deleteAlarmByIdCoreData(id: alarm.id) {
            return
        }
        if let index = getIndexOfAlarm(id: alarm.id) {
            alarms.remove(at: index)
        }
        // delete from CoreData
       
       
        var newAlarm = alarm
        newAlarm.hour = hour
        newAlarm.minute = minute
        newAlarm.days = daysSelected
        newAlarm.id = alarm.id
        print("Updated alarm is now \(newAlarm)")
        alarms.append(newAlarm)
        addAlarmCoreData(alarm: newAlarm)
    }
    
    func toggleOnOff(id: UUID, isOn: Bool) {
        
        if let index = getIndexOfAlarm(id: id) {
            alarms[index].isOn = isOn
            
            // delele alarm in core
            if deleteAlarmByIdCoreData(id: id) == true {
                addAlarmCoreData(alarm: alarms[index])
            }
            // add same alarm in core with isOn set
           
        }
    }
    func getIndexOfAlarm(id: UUID) ->Int? {
        return alarms.firstIndex(where: { $0.id == id })
    }
    
    
}

