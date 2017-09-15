//
//  CoreDataViewController.swift
//  MyVirtualTourist
//
//  Created by Ma Ding on 17/9/14.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import UIKit
import CoreData

// Mark: CoreDataTableViewController: UITableViewController

class CoreDataTableViewController: UITableViewController {
    
    // Mark: Properties
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            // Whenever the fetchedResultsController changes, we execute the search and reload the table
            //fetchedResultsController?.delegate = self
            //executeSearch()
            tableView.reloadData()
            
        }
    }
    
    // Mark: Initializers
    
    init(fetchedResultsController fc: NSFetchedResultsController<NSFetchRequestResult>, style: UITableViewStyle = .plain) {
        fetchedResultsController = fc
        super.init(style: style)
    }
    
    // Do not worry about this initializer. I has to be implemented because of the way Swift interfaces with an Objective C protocol called NSArchiving. It's not relevant.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
