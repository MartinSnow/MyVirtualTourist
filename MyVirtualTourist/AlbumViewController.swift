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

class albumViewController: UIViewController, UICollectionViewDelegate, MKMapViewDelegate {
    
    // Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var albumCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.showAnnotations([Constants.annotation], animated: false)
    }
    
    // Reload photos album
    @IBAction func loadNewPhotos(_ sender: AnyObject) {
    }
    
    
}
