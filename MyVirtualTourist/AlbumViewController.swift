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

class albumViewController: UIViewController {
    
    // Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var albumCollection: UICollectionView!
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    
    var coordinate: CLLocationCoordinate2D?
    var tappedPinLocation: Location?
    var latitude: Double?
    var longitude: Double?
    
    // Store an array of cells that the user tapped to be deleted.
    var tappedIndexPaths = [IndexPath]()
    var insertedIndexPaths: [IndexPath]!
    var deletedIndexPaths: [IndexPath]!
    var updatedIndexPaths: [IndexPath]!
    
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
        
        albumCollection.delegate = self
        albumCollection.dataSource = self
    }
    
    func loadPhotos(pageNumber: Int) {
        GetImageUrls.sharedInstance.getImageUrls(latitude: latitude!, longitude: longitude!, pageNumber: pageNumber){(success, photosUrl, error) in
            if success {
                
                for url in photosUrl! {
                    let photo = Album(location: self.tappedPinLocation!, imageUrl: url, context: self.stack.context)
                    //print("photo is \(photo)")
                }
                do {
                    try self.stack.context.save()
                    print("save url")
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
        annotation.coordinate = coordinate!
        mapView.addAnnotation(annotation)
        
        // Zoom map to the correct region for showing the pin
        self.mapView.centerCoordinate = self.coordinate!
        // Instantiate an MKCoordinateSpanMake to pass into MKCoordinateRegion
        let coordinateSpan = MKCoordinateSpanMake(0.1,0.1)
        // Instantiate an MKCoordinateRegion to pass into setRegion.
        let coordinateRegion = MKCoordinateRegion(center: coordinate!, span: coordinateSpan)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // Delete the photos selected by the user from Core Data.
    func deleteSelectedPhotos() {
        
        // Delete the photos corresponding to the indexes stored in self.tappedIndexPaths (populated in didSelectItemAt)
        for indexPath in tappedIndexPaths {
            
            stack.context.delete(fetchedResultsController.object(at: indexPath as IndexPath) as! Album)
        }
        
        do {
            try stack.context.save()
        } catch {
            print("Error saving the context after deleting photos")
        }
        
        albumCollection.reloadData()
    }
    
    // Delete all the existing photos when the users presses Refresh collection.
    func deleteAllPhotos() {
        
        for object in fetchedResultsController.fetchedObjects! {
            
            stack.context.delete(object as! Album)
            print("delete photos")
        }
    }
    
    // Tap the button
    @IBAction func deleteOrRefresh(_ sender: AnyObject) {
        if barButtonItem.title == "Remove selected pictures" {
            
            deleteSelectedPhotos()
            
            self.barButtonItem.title = "Refresh collection"
            
        } else {
            print("Clicked Refresh collection")
            
            deleteAllPhotos()
            
            GetImageUrls.sharedInstance.getNumbersofPages(latitude: self.latitude!, longitude: self.longitude!) { (success, numberOfPages, error) in
                
                if success {
                    
                    let pageNumber = (arc4random_uniform(UInt32(100)))
                    print("pageNumber is \(pageNumber)")
                    self.loadPhotos(pageNumber: Int(pageNumber))
                }
            }
        }

    }
}

extension albumViewController: UICollectionViewDataSource {
    
    // Find number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as! photoCollectionViewCell
        
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.hidesWhenStopped = true
        
        // The fr should have access to the photo URLs downloaded in loadPhotos()
        let photoToLoad = fetchedResultsController.object(at: indexPath) as! Album
        
        // If no photo exists in Core Data, then download a photo from Flickr.
        if photoToLoad.imageData == nil {
            GetImageUrls.sharedInstance.downloadPhotoWith(url: photoToLoad.imageUrl!) { (success, imageData, error) in
                
                DispatchQueue.main.async {
                    cell.photoImageView.image = UIImage(data: imageData as! Data)
                    cell.activityIndicator.stopAnimating()
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
                cell.activityIndicator.stopAnimating()
            }
        }
        return cell
     }
}

// MARK: UICollectionViewDelegate
extension albumViewController: UICollectionViewDelegate {
    
    // Things to do when a user taps photo cells
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Fade out selected cells
        let cell = collectionView.cellForItem(at: indexPath as IndexPath)
        cell?.alpha = 0.5
        
        // Whenever user selects one or more cells, the bar button changes to Remove seleceted pictures
        self.barButtonItem.title = "Remove selected pictures"
        
        self.tappedIndexPaths.append(indexPath)
    }
    
}

// MARK: NSFetchedResultsControllerDelegate
extension albumViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        insertedIndexPaths = [IndexPath]()
        deletedIndexPaths = [IndexPath]()
        updatedIndexPaths = [IndexPath]()
    }
    
    // https://www.youtube.com/watch?v=0JJJ2WGpw_I (13:50-15:00)
    // This method is only called when anything in the context has been added or deleted. It collects the indexPaths that have changed. Then, in controllerDidChangeContent, the changes are applied to the UI.
    // The indexPath value is nil for insertions, and the newIndexPath value is nil for deletions.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            insertedIndexPaths.append(newIndexPath!)
            print("Inserted a new index path")
            break
            
        case .delete:
            deletedIndexPaths.append(indexPath!)
            print("Deleted an index path")
            break
            
        case .update:
            updatedIndexPaths.append(indexPath!)
            print("Updated an index path")
            break
            
        default:
            break
        }
    }
    
    // https://www.youtube.com/watch?v=0JJJ2WGpw_I (18:15)
    // Updates the UI so that it syncs up with Core Data. This method doesn't change anything in Core Data.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        albumCollection.performBatchUpdates({
            
            for indexPath in self.insertedIndexPaths{
                self.albumCollection.insertItems(at: [indexPath as IndexPath])
            }
            
            for indexPath in self.deletedIndexPaths{
                self.albumCollection.deleteItems(at: [indexPath as IndexPath])
            }
            
            for indexPath in self.updatedIndexPaths{
                self.albumCollection.reloadItems(at: [indexPath as IndexPath])
            }
            
            }, completion: nil)
        
    }
    
}
