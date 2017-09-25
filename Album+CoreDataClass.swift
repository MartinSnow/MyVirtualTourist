//
//  Album+CoreDataClass.swift
//  MyVirtualTourist
//
//  Created by Ma Ding on 17/9/25.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import Foundation
import CoreData


public class Album: NSManagedObject {
    
    convenience init(location: Location, imageUrl: String, context: NSManagedObjectContext) {
        
        // An EntityDescription is an object that has access to all the information you provided in the Entity part of the model. You need it to create an instance of this class.
        if let ent = NSEntityDescription.entity(forEntityName: "Album", in: context) {
            
            // Calling designated initializer
            self.init(entity: ent, insertInto: context)
            self.location = location
            self.imageUrl = imageUrl
        } else {
            fatalError("Unable to find Entity name!")
        }
    }


}
