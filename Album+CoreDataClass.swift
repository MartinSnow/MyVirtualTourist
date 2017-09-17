//
//  Album+CoreDataClass.swift
//  MyVirtualTourist
//
//  Created by Ma Ding on 17/9/15.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import Foundation
import CoreData


public class Album: NSManagedObject {
    
    // Mark: Initializer
    convenience init(imageData: Data, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "Album", in: context) {
            self.init(entity:entity, insertInto: context)
            self.imageData = imageData as NSData?
            self.creationDate = NSDate()
        } else {
            fatalError("Unable to find Entity name!")
        }
    }

}
