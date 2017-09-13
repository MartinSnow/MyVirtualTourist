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
    func addAPin(_ sender: UILongPressGestureRecognizer){
        
        // Create an annotation model
        let annotation = MKPointAnnotation()
        
        // Add annotation's properties
        annotation.coordinate = coordinate
        annotation.title = "title"
        annotation.subtitle = "subtitle"
        
        // Add annotation model on the map
        mapView.addAnnotation(annotation)
    }
    
    // Get the location
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Get the touch point location
        let point = touches.first?.location(in: mapView)
        
        // Turn the location to coordinate
        coordinate = mapView.convert(point!, toCoordinateFrom: mapView)
    }
}


