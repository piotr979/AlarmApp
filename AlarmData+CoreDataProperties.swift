//
//  AlarmData+CoreDataProperties.swift
//  AlarmusUI
//
//  Created by Piotr Glaza on 09/01/2021.
//
//

import Foundation
import CoreData


extension AlarmData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlarmData> {
        return NSFetchRequest<AlarmData>(entityName: "AlarmData")
    }

    @NSManaged public var days: [Bool]
    @NSManaged public var hour: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var isOn: Bool
    @NSManaged public var minute: Int16

}

extension AlarmData : Identifiable {

}
