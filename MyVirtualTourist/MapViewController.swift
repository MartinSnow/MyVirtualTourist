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
        location.pinCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        print("lat is \(location.pinCoordinate.latitude) and lon is \(location.pinCoordinate.longitude)")
        
        // Create pin annotation
        location.pinAnnotation = Annotation(title: "title", subtitle: "subtitle", coordinate: location.pinCoordinate)
        
        // Add pin on the map
        mapView.addAnnotation(location.pinAnnotation)
    }
    
    // Go to Album Collection
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let pinAnnotation = view.annotation {
        
            Constants.FlickrParameterValues.LatValue = Float(pinAnnotation.coordinate.latitude)
            Constants.FlickrParameterValues.LonValue = Float(pinAnnotation.coordinate.longitude)
        } else {
            print("pinAnnotation is nil")
            return
        }
        
        getPhotosData() {(error) in
            if error != nil {
                print("There was an error with your request: \(error)")
            } else {
                performUIUpdatesOnMain {
                    let AlbumViewController = self.storyboard!.instantiateViewController(withIdentifier: "AlbumViewController")
                    self.navigationController!.pushViewController(AlbumViewController, animated: true)
                }
            }
        }
        
    }
}



