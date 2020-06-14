//
//  Person+CoreDataProperties.swift
//  ManyScreens
//
//  Created by Rafal_O on 26.05.2020.
//  Copyright © 2020 Rafal_O. All rights reserved.
//
//

import Foundation
import CoreData

extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

}
