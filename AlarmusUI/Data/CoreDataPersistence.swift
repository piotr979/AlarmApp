//
//  CoreDataPersistence.swift
//  AlarmusUI
//
//  Created by Piotr Glaza on 09/01/2021.
//

import UIKit
import CoreData
class CoreDataPersistence {
    
    static let shared = CoreDataPersistence()
    lazy var persitentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
        })
        return container
    }()
}
