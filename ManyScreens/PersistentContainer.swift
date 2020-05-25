//
//  PersistentContainer.swift
//  ManyScreens
//
//  Created by Rafal_O on 25.05.2020.
//  Copyright © 2020 Rafal_O. All rights reserved.
//

import UIKit
import CoreData

class PersistentContainer: NSPersistentContainer {

    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
}
