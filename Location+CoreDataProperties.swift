//
//  Location+CoreDataProperties.swift
//  MyVirtualTourist
//
//  Created by Ma Ding on 17/9/23.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import Foundation
import CoreData

extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location");
    }

    @NSManaged public var latitudeValue: Double
    @NSManaged public var longitudeValue: Double
    @NSManaged public var album: Album?

}
