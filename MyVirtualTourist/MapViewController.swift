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
    
    public var coordinate = CLLocationCoordinate2D()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set mapView's delegate
        mapView.delegate = self
        
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
        print("lat is \(coordinate.latitude) and lon is \(coordinate.longitude)")
        
        // Create an annotation model
        let annotation = MKPointAnnotation()
        Constants.FlickrParameterValues.LatValue = Float(coordinate.latitude)
        Constants.FlickrParameterValues.LonValue = Float(coordinate.longitude)
        
        // Add annotation's properties
        annotation.coordinate = coordinate
        annotation.title = "title"
        annotation.subtitle = "subtitle"
        
        // Add annotation model on the map
        mapView.addAnnotation(annotation)
    }
    
    // Go to Album Collection
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        getPhotosData()
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "AlbumViewController")
        self.present(controller, animated: true, completion: nil)
    }
}


