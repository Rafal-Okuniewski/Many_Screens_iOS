//
//  Person.swift
//  ManyScreens
//
//  Created by Rafal_O on 11.05.2020.
//  Copyright © 2020 Rafal_O. All rights reserved.
//

import UIKit

class Person {
    
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
    
}
