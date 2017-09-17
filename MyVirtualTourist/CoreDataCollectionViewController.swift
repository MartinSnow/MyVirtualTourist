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
            executeSearch()
            collectionView?.reloadData()
        }
    }
    
    // Mark: Initializers
    
    init(fetchedResultsController fc: NSFetchedResultsController<NSFetchRequestResult>, collectionViewLayout: UICollectionViewFlowLayout) {
        fetchedResultsController = fc
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    // Do not worry about this initializer. I has to be implemented because of the way Swift interfaces with an Objective C protocol called NSArchiving. It's not relevant.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// Mark: CoreDataTableViewController (Subclass Must Implement)
extension coreDataCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("This method MUST be implemented by a subclass of CoreDataTableViewController")
    }
}

// Mark: CoreDataTableViewController (Table Data Source)

extension coreDataCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let fc = fetchedResultsController {
            return (fc.sections?.count)!
        } else {
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let fc = fetchedResultsController {
            return fc.sections![section].numberOfObjects
        } else {
            return 0
        }
    }
}

// Mark: CoreDataTableViewController (Fetches)

extension coreDataCollectionViewController {
    
    func executeSearch() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            } catch let error as NSError {
                print("Error while trying to perform a search: \n\(error)\n\(fetchedResultsController)")
            }
        }
    }
    
}

// MARK: - CoreDataTableViewController: NSFetchedResultsControllerDelegate

extension coreDataCollectionViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
}
