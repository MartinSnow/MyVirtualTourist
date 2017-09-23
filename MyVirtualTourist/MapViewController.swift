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

class mapViewController: UIViewController, MKMapViewDelegate {
    
    // Mark: Properties
    var latitude: Double?
    var longitude: Double?
    var coordinate: CLLocationCoordinate2D?
    var annotation: MKPointAnnotation?
    var locations: [Location]?
    
    // Get the stack
    let stack = (UIApplication.shared.delegate as! AppDelegate).stack
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set mapView's delegate
        mapView.delegate = self
        
        // Display pins that created before
        loadPins()
        
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
        self.coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        self.annotation = MKPointAnnotation()
        self.annotation?.coordinate = self.coordinate!
        self.latitude = self.coordinate?.latitude
        self.longitude = self.coordinate?.longitude
        //print("lat is \(self.latitude) and lon is \(self.longitude)")
        
        // Add pin on the map
        mapView.addAnnotation(annotation!)
        
        // Save location
        let location = Location(latitude: self.latitude!, longitude: self.longitude!, context: stack.context)
        locations?.append(location)
        print("locations is \(locations)")
        do {
            try stack.context.save()
            print("save locations")
        } catch {
            print("Error saving the locations")
        }
    }
    
    // Load pins that previously created
    func loadPins() {
        
        // Create a fetch request
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        fr.sortDescriptors = [NSSortDescriptor(key: "latitudeValue", ascending: true)]
        
        // Fetch the Location objects in the context.
        do {
            locations = try stack.context.fetch(fr) as? [Location]
            print("locations is \(locations)")
        } catch {
            print(error.localizedDescription)
        }
        
        // Display pins on the map
        for pin in locations! {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitudeValue, longitude: pin.longitudeValue)
            mapView.addAnnotation(annotation)
        }
        print("display pins")
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



