//
//  PersonModel.swift
//  ManyScreens
//
//  Created by Rafal_O on 25.05.2020.
//  Copyright © 2020 Rafal_O. All rights reserved.
//

import UIKit
import Foundation
import CoreData

public class PersonModel: NSManagedObject {
    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var birth: Date?
    @NSManaged public var photo: UIImage?
}

extension PersonModel {
    static func getAllPeople() -> NSFetchRequest<PersonModel>{
    let request:NSFetchRequest<PersonModel> = PersonModel.fetchRequest() as! NSFetchRequest<PersonModel>
        
        let sortDescriptor = NSSortDescriptor(key: "surname", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
