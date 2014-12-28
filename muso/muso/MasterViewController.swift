//
//  MasterViewController.swift
//  muso
//
//  Created by John May on 3/10/2014.
//  Copyright (c) 2014 John May. All rights reserved.
//

import UIKit
import Realm
import Haneke

class MasterViewController: UITableViewController, UISearchResultsUpdating {

    var detailViewController: DetailViewController? = nil
    var objects = [ArtistResult]()
    var searchController = UISearchController()

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        
        self.searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self;
            controller.searchBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 44.0)
            self.tableView.tableHeaderView = controller.searchBar
            self.definesPresentationContext = true
            return controller
        })()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects.insert(ArtistResult(id: 0,title: "",thumb: NSURL(),resource_url: NSURL(),type: "",uri: ""), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = objects[indexPath.row] as ArtistResult
                
//                 TODO Get details
//                let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
//                controller.detailItem =
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let object = objects[indexPath.row] as ArtistResult

        if let (textLabel, imageView) = unwrap(cell.textLabel, cell.imageView) {
            textLabel.text = object.title
            imageView.frame = CGRectMake(0, 0, 40, 40)
            if let maybeThumb = object.thumb {
                println(maybeThumb)
                imageView.hnk_setImageFromURL(maybeThumb)
            }
        }
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if (searchController.searchBar.text.utf16Count > 3) {
            Api().search(Resource.allObjects(), searchQuery:searchController.searchBar.text, {
                (results:[ArtistResult]) in
                let count: Int? = results.count
                if let ct = count {
                    self.objects.removeAll(keepCapacity: false)
                    self.objects += results
                    self.tableView.reloadData()
                }
            })
        }
    }
}

