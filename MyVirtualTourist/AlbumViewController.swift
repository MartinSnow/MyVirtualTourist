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

class albumViewController: coreDataCollectionViewController, MKMapViewDelegate {
    
    // Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var albumCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.albumCollection.dataSource = self
        self.albumCollection.delegate = self
        // Show the pin
        let spanLevel: CLLocationDistance = 2000
        self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(pinLocation.pinCoordinate, spanLevel, spanLevel), animated: true)
        self.mapView.addAnnotation(pinLocation.pinAnnotation)
        
        // Set the title
        title = "Photo Album"
        
        //Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        // Create a fetchrequest
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
        fr.sortDescriptors = [NSSortDescriptor(key: "imageData", ascending: false),NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // Create the FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Put photos in core data
        let photoURLs = Constants.photosUrl
        for photoUrLString in photoURLs {
            let photoURL = URL(string: photoUrLString)
            if let photoData = try? Data(contentsOf: photoURL!) {
                let photo = Album(imageData: photoData, context: fetchedResultsController!.managedObjectContext)
            } else {
                print("Image does not exist at \(photoURL)")
            }
        }
    }
    
    // Find number of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as! photoCollectionViewCell
        let album = fetchedResultsController!.object(at: indexPath) as! Album
        performUIUpdatesOnMain {
            cell.photoImageView?.image = UIImage(data: album.imageData as! Data)
        }
        return cell
    }
    
    // Reload photos album
    @IBAction func loadNewPhotos(_ sender: AnyObject) {
    }
    
    
}
