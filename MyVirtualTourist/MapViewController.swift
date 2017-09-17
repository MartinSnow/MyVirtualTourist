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

class mapViewController: coreDataCollectionViewController, MKMapViewDelegate {
    
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
        
        // Set the title
        title = "World Map"
        
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        // Create a fetchrequest
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName:"Location")
        fr.sortDescriptors = [NSSortDescriptor(key: "locationName", ascending: false), NSSortDescriptor(key: "latitudeValue", ascending: false), NSSortDescriptor(key: "longitudeValue", ascending: false), NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // Create the FetchResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
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
        pinLocation.pinCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        print("lat is \(pinLocation.pinCoordinate.latitude) and lon is \(pinLocation.pinCoordinate.longitude)")
        
        // Get location's name and latitude and longitude
        let location = Location(locationName: "location", latitudeValue: Float(pinLocation.pinCoordinate.latitude), longitudeValue: Float(pinLocation.pinCoordinate.longitude), context: fetchedResultsController!.managedObjectContext)
        print("Just created a notebook: \(location)")
        
        // Create pin annotation
        pinLocation.pinAnnotation = Annotation(title: "title", subtitle: "subtitle", coordinate: pinLocation.pinCoordinate)
        
        // Add pin on the map
        mapView.addAnnotation(pinLocation.pinAnnotation)
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



