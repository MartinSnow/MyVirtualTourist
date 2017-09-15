//
//  Album+CoreDataProperties.swift
//  MyVirtualTourist
//
//  Created by Ma Ding on 17/9/14.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import Foundation
import CoreData

extension Album {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album");
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var imageData: NSData?
    @NSManaged public var location: Location?

}
