//
//  Location+CoreDataProperties.swift
//  MyVirtualTourist
//
//  Created by Ma Ding on 17/9/25.
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
    @NSManaged public var album: NSSet?

}

// MARK: Generated accessors for album
extension Location {

    @objc(addAlbumObject:)
    @NSManaged public func addToAlbum(_ value: Album)

    @objc(removeAlbumObject:)
    @NSManaged public func removeFromAlbum(_ value: Album)

    @objc(addAlbum:)
    @NSManaged public func addToAlbum(_ values: NSSet)

    @objc(removeAlbum:)
    @NSManaged public func removeFromAlbum(_ values: NSSet)

}
