//
//  Location+CoreDataProperties.swift
//  MyVirtualTourist
//
//  Created by Ma Ding on 17/9/14.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import Foundation
import CoreData

extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location");
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var locationName: String?
    @NSManaged public var coordinate: NSObject?
    @NSManaged public var album: Album?

}
