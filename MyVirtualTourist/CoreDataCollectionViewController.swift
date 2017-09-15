//
//  CoreDataCollectionViewController.swift
//  MyVirtualTourist
//
//  Created by Ma Ding on 17/9/15.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import UIKit
import CoreData

class coreDataCollectionViewController: UICollectionViewController {
    
    // Mark: Properties
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {
    
        didSet {
            // Whenever the frc changes, we execute the search and
            // reload the table
            fetchedResultsController?.delegate = self
            //executeSearch()
            collectionView?.reloadData()
        }
    }
}

// MARK: - CoreDataTableViewController: NSFetchedResultsControllerDelegate

extension coreDataCollectionViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
}
