//
//  MapViewController.swift
//  MyVirtualTourist
//
//  Created by Ma Ding on 17/9/13.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class mapViewController: CoreDataTableViewController, MKMapViewDelegate {
    
    // Mark: Properties
    
    var touchCoordinate = CLLocationCoordinate2D()
    
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
    }
}
