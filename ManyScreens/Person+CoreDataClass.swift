//
//  Person+CoreDataClass.swift
//  ManyScreens
//
//  Created by Rafal_O on 26.05.2020.
//  Copyright © 2020 Rafal_O. All rights reserved.
//
//

import Foundation
import CoreData

public class Person: NSManagedObject {
    
    @NSManaged public var birth: NSDate
    @NSManaged public var name: String
    @NSManaged public var photo: NSData?
    @NSManaged public var surname: String
    
}
