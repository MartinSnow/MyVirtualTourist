//
//  Location+CoreDataClass.swift
//  MyVirtualTourist
//
//  Created by Ma Ding on 17/9/30.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import Foundation
import CoreData


public class Location: NSManagedObject {
    
    convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        
        // An EntityDescription is an object that has access to all the information you provided in the Entity part of the model. You need it to create an instance of this class.
        if let ent = NSEntityDescription.entity(forEntityName: "Location", in: context) {
            
            // Calling designated initializer
            self.init(entity: ent, insertInto: context)
            self.latitudeValue = latitude
            self.longitudeValue = longitude
        } else {
            fatalError("Unable to find Entity name!")
        }
    }


}
