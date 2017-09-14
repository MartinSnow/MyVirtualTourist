//
//  MapViewController.swift
//  MyVirtualTourist
//
//  Created by Ma Ding on 17/9/13.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import UIKit
import MapKit

class mapViewController: UIViewController, MKMapViewDelegate {
    
    // Mark: Properties
    
    var coordinate = CLLocationCoordinate2D()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add longPress gesture
        let longPress = UILongPressGestureRecognizer(target:self,
                                                     action:#selector(addAPin(_:)))
        self.view.addGestureRecognizer(longPress)
    }
    
    // Add a pin on the map
    func addAPin(_ gestureRecognizer: UIGestureRecognizer){
        
        // Check start state
        if gestureRecognizer.state != .began {
            return
        }
        
        // Get the touch point location
        let touchPoint = gestureRecognizer.location(in: mapView)
        
        // Turn the location to coordinate
        coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        // Create an annotation model
        let annotation = MKPointAnnotation()
        
        // Add annotation's properties
        annotation.coordinate = coordinate
        annotation.title = "title"
        annotation.subtitle = "subtitle"
        
        // Add annotation model on the map
        mapView.addAnnotation(annotation)
    }
}


