//
//  Location+CoreDataClass.swift
//  MyVirtualTourist
//
//  Created by Ma Ding on 17/9/15.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import Foundation
import CoreData


public class Location: NSManagedObject {
    convenience init(locationName: String, latitudeValue: Float, longitudeValue: Float, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "Album", in: context) {
            self.init(entity:entity, insertInto: context)
            self.locationName = locationName
            self.latitudeValue = latitudeValue
            self.longitudeValue = longitudeValue
            self.creationDate = NSDate()
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
