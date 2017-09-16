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

class albumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate {
    
    // Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var albumCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.showAnnotations([Constants.annotation], animated: false)
    }
    
    // Find number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.photosUrl.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as! photoCollectionViewCell
        let photoURL = URL(string: Constants.photosUrl[(indexPath as NSIndexPath).item])
        if let photoData = try? Data(contentsOf: photoURL!) {
            performUIUpdatesOnMain {
                cell.photoImageView?.image = UIImage(data: photoData)
            }
        } else {
            print("Image does not exist at \(photoURL)")
        }
        return cell
    }
    
    // Reload photos album
    @IBAction func loadNewPhotos(_ sender: AnyObject) {
    }
    
    
}
