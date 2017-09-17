//
//  Annotation.swift
//  MyVirtualTourist
//
//  Created by Ma Ding on 17/9/17.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import MapKit

class Annotation: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
