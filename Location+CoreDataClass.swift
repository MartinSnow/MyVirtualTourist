//
//  Location+CoreDataClass.swift
//  MyVirtualTourist
//
//  Created by Ma Ding on 17/9/14.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import Foundation
import CoreData
import MapKit


public class Location: NSManagedObject {

    //Mark: Initializer
    
    convenience init(locationName: String?, coordinate: CLLocation, context: NSManagedObjectContext) {
        
        // An EntityDescription is an object that has access to all the information you provide in the Entity part of the model, you need it to create an instance of this class.
        if let entity = NSEntityDescription.entity(forEntityName: "location", in: context) {
            self.init(entity: entity, insertInto: context)
            self.locationName = locationName
            self.coordinate = coordinate
            self.creationDate = NSDate()
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
