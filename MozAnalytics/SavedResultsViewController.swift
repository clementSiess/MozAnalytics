//
//  SavedResultsViewController.swift
//  MozAnalytics
//
//  Created by Siess, Clement on 9/22/15.
//  Copyright (c) 2015 Siess, Clement. All rights reserved.
//

import UIKit
import CoreData

class SavedResultsViewController: UITableViewController{
    
    @IBOutlet var mozResultsTableView: UITableView!
    
    var mozResults = [MozResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mozResultsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        mozResultsTableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "MozResult")
        
        // var error: NSError?
        let fetchResults = try? managedContext.executeFetchRequest(fetchRequest) as? [MozResult]
        
        if let results = fetchResults {
            mozResults = results!
            mozResultsTableView.reloadData()
        
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        // 1. Check for credentials
        if NSUserDefaults.standardUserDefaults().boolForKey("hasCredentials") == false{
            
            // 2. No credentials, send to settings
            self.tabBarController?.selectedIndex = 2
            return
        }else if (mozResults.count < 1){
            // No results, send to search
            self.tabBarController?.selectedIndex = 1
            return
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? DetailViewController{
            if let indexPath = tableView.indexPathsForSelectedRows?.first {
                destination.mozResult = mozResults[indexPath.row]
                
            }
        }
    }
    
    //MARK
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mozResults.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mozResult = mozResults[indexPath.row]
        
        let cell = self.mozResultsTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        
        cell.textLabel!.text = mozResult.canonicalURL
        
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor(red:255/255, green:102/255, blue:102/255, alpha:1.0)
        }
        else{
            cell.backgroundColor = UIColor(red:30/255, green:144/255, blue:255/255, alpha:1.0)
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
        }
        
        return cell
    }
    
    // To delete a cell view
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            managedContext?.deleteObject(mozResults[indexPath.row] as MozResult)
            do {
                try managedContext?.save()
                
            } catch _ {
            }
            
            mozResults.removeAtIndex(indexPath.row)
            mozResultsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showDetail", sender: indexPath)
    }
    
    
    
}
