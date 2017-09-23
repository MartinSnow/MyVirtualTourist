//
//  AlbumViewController.swift
//  MyVirtualTourist
//
//  Created by Ma Ding on 17/9/15.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class albumViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var albumCollection: UICollectionView!
    
    var coordinate: CLLocationCoordinate2D?
    var tappedPinLocation: Location?
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        
        // Create a fetch request to specify what objects this fetchedResultsController tracks.
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
        fr.sortDescriptors = [NSSortDescriptor(key: "imageUrl", ascending: true)]
        
        // Specify that we only want the photos associated with the tapped pin. (pin is the relationships)
        fr.predicate = NSPredicate(format: "location = %@", self.tappedPinLocation!)
        
        // Create and return the FetchedResultsController
        return NSFetchedResultsController(fetchRequest: fr, managedObjectContext: self.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
    }()
    
    // Get the stack
    let stack = (UIApplication.shared.delegate as! AppDelegate).stack
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayPin()
        fetchedResultsController.delegate = self
        
        // Check if this pin has photos stored in Core Data.
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error while trying to perform a search: \n\(error)\n\(fetchedResultsController)")
        }
        
        let fetchedObjects = fetchedResultsController.fetchedObjects
        if fetchedObjects?.count == 0 {
            loadPhotos(pageNumber: 1)
        }
    }
    
    func loadPhotos(pageNumber: Int) {
        GetImageUrls.sharedInstance.getImageUrls(pageNumber: pageNumber){(success, photosUrl, error) in
            if success {
                
                for url in photosUrl! {
                    let photo = Album(location: self.tappedPinLocation!, imageUrl: url, context: self.stack.context)
                    print("photo is \(photo)")
                }
                do {
                    try self.stack.context.save()
                } catch {
                    print("Error saving the url")
                }
                
                DispatchQueue.main.async {
                    self.albumCollection.reloadData()
                }
                
            } else {
                print("Error loading photos")
            }
        }
    }
    
    func displayPin() {
        let annotation = MKPointAnnotation()
        let spanLevel: CLLocationDistance = 2000
        let coordinate = CLLocationCoordinate2D(latitude: tappedPinLocation!.latitudeValue, longitude: tappedPinLocation!.longitudeValue)
        annotation.coordinate = coordinate
        self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(coordinate, spanLevel, spanLevel), animated: true)
        self.mapView.addAnnotation(annotation)
    }
    
    // Reload photos album
    @IBAction func loadNewPhotos(_ sender: AnyObject) {
    }
}

extension albumViewController {
    
    // Find number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections![0].numberOfObjects
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as! photoCollectionViewCell
        // The fr should have access to the photo URLs downloaded in loadPhotos()
        let photoToLoad = fetchedResultsController.object(at: indexPath) as! Album
        
        // If no photo exists in Core Data, then download a photo from Flickr.
        if photoToLoad.imageData == nil {
            GetImageUrls.sharedInstance.downloadPhotoWith(url: photoToLoad.imageUrl!) { (success, imageData, error) in
                
                DispatchQueue.main.async {
                    cell.photoImageView.image = UIImage(data: imageData as! Data)
                }
                
                // Save the photo's corresponding imageData to Core Data.
                photoToLoad.imageData = imageData
                
                do {
                    try self.stack.context.save()
                } catch {
                    print("Error saving the imageData")
                }
            }
            
            // Else, photoToLoad.imageData already exists in the fetchedResultsController. Display it in the UI.
        } else {
            
            DispatchQueue.main.async {
                cell.photoImageView.image = UIImage(data: photoToLoad.imageData as! Data)
            }
        }
        return cell
     }
}
