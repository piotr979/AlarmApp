//
//  Helpers.swift
//  AlarmusUI
//
//  Created by Piotr Glaza on 01/12/2020.
//

import Foundation
import Combine
enum AlarmStatus {
    case alarmOn
    case alarmOff
}
class Helpers {
    

   
    
    // SINGLETON DEFINITION
    // HERE
    static let shared = Helpers()
    
    var alarmStatus: AlarmStatus = .alarmOff 
    
    func formatAlarmUnitForDisplay(_ unit: Int) ->String {
        return unit < 10 ? "0\(unit)" : "\(unit)"
    }
    func processPickerTime(_ value: Date) ->(Int,Int) {
        
        let mns = Calendar.current.component(.minute, from: value)
        let hrs = Calendar.current.component(.hour, from: value)
        return (hrs,mns)
    }
    func convertTimeToNumber(hour: Int, minute: Int) ->Int {
        return ((hour * 60) + minute)
    }
    func findAlarmIdForNotification(alarms: [Alarm]) ->(alarmId: UUID, day: Int, hourLeft: Int, minuteLeft: Int, daysLeft: Int )? {
        
        // 1.get time for today
        let today = Date().day
        let currentHour = Date().currentHour
        let currentMinute = Date().currentMinute
        let currentTimeIntegered = Helpers.shared.convertTimeToNumber(hour: currentHour, minute: currentMinute)
        
        // 2. find alarms which are on
        
        var alarmsSwitchedOn: [Alarm] = []
        for alarm in alarms {
            if alarm.isOn == true {
                alarmsSwitchedOn.append(alarm)
            }
        }
        // if there is no alarm switched on just return nil
        if alarmsSwitchedOn.count == 0 {
            return nil
        }
        // ----------- RETURNS NIL
        
        
       
        // the list is ready
        // we start with today after current Time
        
        let todayAlarmsAterCurrentTime =  tryToFindAlarmForSpecificDay(alarms: alarmsSwitchedOn, day: today)
        if let alarmsForToday = todayAlarmsAterCurrentTime {
            
            // we have alarms for today
            // 1. convert currentTime To Integer
         
           
            // 2. convert all alarm times to Ints and
            
            let alarmsConvertedToInt = convertAlarmsTimeToInt(alarms: alarmsForToday)
          
            // 3. find alarms bigger than currentTime
            var alarmsForTodayFuture:[UUID: Int] = [:]
            for alarm in alarmsConvertedToInt {
                if alarm.value == currentTimeIntegered {
                    // TODO: What to do when alarm time is same as current time???
                }
                if alarm.value > currentTimeIntegered {
                    alarmsForTodayFuture[alarm.key] = alarm.value
                }
            }
            
            // 4. We have: alarms convert to Int and today time To Int. Time to find closest alarm
            if let alarmUuid = findNextAlarm(uuidWithTime: alarmsForTodayFuture) {
                print("Found alarm for today is \(alarmUuid)")
                
                guard let alarmFound = alarms.first(where: { $0.id == alarmUuid }) else { return nil }
                let timeLeft = calcTimeLeftTillAlarm(currentTimeInt: currentTimeIntegered, alarm: alarmFound, daysAhead: 0)
                return (alarmUuid, today, hourLeft: timeLeft.hourLeft, minuteLeft: timeLeft.minuteLeft, daysLeft: timeLeft.daysLeft)
                // TODO: return alarm with UUID
            }
            
        }
        
        // ------------------ find for next days if not found for toda
        // now we need to loop next days
        // if nothing found loop for the same like first time but with times earlier than current time
        
        // builds list with days in correct order (starting with for ex. Saturday - 5)
         // its 7 instead of 6 to cover today but past time
        
        var tempListOfDaysToCheck: [Int] = []
        var x = today + 1
         for _ in 0...6 {
            if x == 7 {
                 x = 0
             }
             tempListOfDaysToCheck.append(x)
            
            x += 1
         }
        print("Our list for inspection is \(tempListOfDaysToCheck)")
        for (index,day) in tempListOfDaysToCheck.enumerated() {
            if let alarmsForSpecificDay = tryToFindAlarmForSpecificDay(alarms: alarmsSwitchedOn, day: day) {
                
               // now when we have list of alarms
                // find the closest
                switch alarmsForSpecificDay.count {
                case 0:
                    continue
                case 1:
                    let timeLeft = calcTimeLeftTillAlarm(currentTimeInt: currentTimeIntegered, alarm: alarmsForSpecificDay[0], daysAhead: index + 1)
                    //return (alarmUuid, today, hourLeft: timeLeft.hourLeft, minuteLeft: timeLeft.minuteLeft, daysLeft: timeLeft.daysLeft)
                    print("case 1 \(alarmsForSpecificDay.count)")
                    return (alarmId: alarmsForSpecificDay[0].id, day: day, hourLeft: timeLeft.hourLeft, minuteLeft: timeLeft.minuteLeft, daysLeft: timeLeft.daysLeft)
                default:
                    // find now the closest time
                    // 1. convert all alarm times to Ints and
                    
                    let alarmsConvertedToInt = convertAlarmsTimeToInt(alarms: alarmsForSpecificDay)
                    // 4. We have: alarms convert to Int and today time To Int. Time to find closest alarm
                    if let alarmUuid = findNextAlarm(uuidWithTime: alarmsConvertedToInt) {
                        print("Found alarm is \(alarmUuid)")
                        let timeLeft = calcTimeLeftTillAlarm(currentTimeInt: currentTimeIntegered, alarm: alarmsForSpecificDay[0], daysAhead: index + 1)
                        return (alarmId: alarmsForSpecificDay[0].id, day: day, hourLeft: timeLeft.hourLeft, minuteLeft: timeLeft.minuteLeft, daysLeft: timeLeft.daysLeft)
                        // TODO: return alarm with UUID
                    }
                  
                }
            } // IF
            
        } // FOR
        return nil
    }
    func calcTimeLeftTillAlarm(currentTimeInt: Int, alarm: Alarm, daysAhead: Int) -> (hourLeft: Int, minuteLeft: Int, daysLeft: Int) {
        let MINUTES24HOURS = 1440
        
        //potrzbny nr aktualna dnia
        // wtorek to 2
        // i ile czasu do nastepnego
        // obecny indeks to 0
        // natomiast dzien to day
        
        //find alarm
        print("Days left \(daysAhead)")
        let alarmTimeWithoutDaysToInt = (convertTimeToNumber(hour: alarm.hour, minute: alarm.minute))
        let daysToNextAlarm = MINUTES24HOURS * (daysAhead)
        
        // we have days and hours of next alarm converted to Int
        let alarmConvertedToInt = alarmTimeWithoutDaysToInt + daysToNextAlarm
        
        print(alarmConvertedToInt)
        let timeLeftInt = alarmConvertedToInt - currentTimeInt
        
        // let say is left 3200 minutes
        // podziel to przez MINUTES24HOURS
        let daysLeft = daysAhead == 0 ? 0 : timeLeftInt / MINUTES24HOURS
        let calcTime = timeLeftInt - ( daysLeft * MINUTES24HOURS)
        let hourLeft = calcTime / 60
        let minuteLeft = calcTime % 60
        return (hourLeft: hourLeft, minuteLeft: minuteLeft, daysLeft: daysLeft)
        
    }
    func tryToFindAlarmForSpecificDay(alarms: [Alarm], day: Int) ->[Alarm]? {
        
        var alarmsOnForSpecificDay: [Alarm] = []
        
        for alarm in alarms {
            if alarm.days[day] == true {
                alarmsOnForSpecificDay.append(alarm)
            }
            
        }
        return alarmsOnForSpecificDay.count != 0 ? alarmsOnForSpecificDay : nil
    }
    func convertAlarmsTimeToInt(alarms: [Alarm]) ->[UUID: Int] {
        var alarmsConvertedToInt: [UUID: Int] = [:]
        for alarm in alarms {
            alarmsConvertedToInt[alarm.id] = Helpers.shared.convertTimeToNumber(hour: alarm.hour, minute: alarm.minute)
        }
        return alarmsConvertedToInt
    }
    func findNextAlarm(uuidWithTime: [UUID: Int]) ->UUID?  {
     
       
        
        let closestAlarmIntegered = uuidWithTime.min { a,b in a.value < b.value }
        print("The closest alarm is \(closestAlarmIntegered)")
        
    
       
        // 7. we dont need to convert time, just find the alarm by ID in our alarm files
        
       
        // it return UUID number of alarm if available
        return closestAlarmIntegered?.key
        
//        if let alarmIndexInAlarms = alarms.firstIndex(where: { $0.id == ut }) {
//            return alarms[alarmIndexInAlarms]
//        } else {
//            return nil
//        }
        
        // RETURN ALARMS FOR FIRST DAY AFTER CURRENT TIME
        
        
    }
//    func areAlarmsForThisDay(day: Int, alarms:[Alarm]) ->[Alarm]? {
//
//    }
    func doesAlarmExistForDay(day: Int, alarms:  [Alarm]) ->Alarm? {
        for alarm in alarms {
            print("Checking alarm \(alarm)")
            if alarm.days[day] == true {
                return alarm
            }
           
        }
        return nil
    }
   
}
