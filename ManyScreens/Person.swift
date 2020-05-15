//
//  Person.swift
//  ManyScreens
//
//  Created by Rafal_O on 11.05.2020.
//  Copyright © 2020 Rafal_O. All rights reserved.
//

import UIKit
import os.log

class Person : NSObject, NSCoding {
    
    struct PropertyKey {
        static let name = "name"
        static let surname = "surname"
        static let birth = "birth"
        static let photo = "photo"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(surname, forKey: PropertyKey.surname)
        aCoder.encode(birth, forKey: PropertyKey.birth)
        aCoder.encode(photo, forKey: PropertyKey.photo)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Person object.", log: OSLog.default, type: .debug)
            return nil
        }

        guard let surname = aDecoder.decodeObject(forKey: PropertyKey.surname) as? String else {
            os_log("Unable to decode the surname for a Person object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let birth = aDecoder.decodeObject(forKey: PropertyKey.birth) as? Date else {
            os_log("Unable to decode the birth for a Person object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        self.init(name: name, surname: surname, birth: birth, photo: photo)
    }
    
    var name: String
    var surname: String
    var birth: Date
    var photo: UIImage?
    
    init?(name: String, surname: String, birth:Date, photo: UIImage?){
        
        guard !name.isEmpty else{
            return nil
        }
        
        guard !surname.isEmpty else {
            return nil
        }
        
        self.name = name
        self.surname = surname
        self.birth = birth
        self.photo = photo
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("people")
    
}
