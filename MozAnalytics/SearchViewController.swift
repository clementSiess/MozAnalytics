//
//  SearchViewController.swift
//  MozAnalytics
//
//  Created by Siess, Clement on 9/17/15.
//  Copyright (c) 2015 Siess, Clement. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var accessID: String?
    var secretKey: String?
    var mozArray: NSArray = ResponseField.stringValues // Let's produce an array of response fields to use
    var mozJSONDictionary: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewDidAppear(animated: Bool) {
        // 1. Check for credentials
        if NSUserDefaults.standardUserDefaults().boolForKey("hasCredentials") == false{
            // 2. No credentials, do someting
            self.tabBarController?.selectedIndex = 2
            
        } else {
            accessID = NSUserDefaults.standardUserDefaults().valueForKey("accessID") as? String
            secretKey = NSUserDefaults.standardUserDefaults().valueForKey("secretKey") as? String
        }
        
    }
    
    func getMozData(searchURL: String) {
        // 1. Create a Mozscape object
        let mozScape = Mozscape(searchURL: searchURL, accessID: accessID!, secretKey: secretKey!)
        // 2. perform lookup
        mozScape.getMozDataFromAPIRequest { (mozJSON) -> Void in
            
            if let mozJSON = mozJSON {
                
                // FIXME: remove loging
                print(NSString(data: mozJSON, encoding: NSUTF8StringEncoding) as! String)
                
                if let jsonDictionary: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(mozJSON, options: .MutableContainers)) as? NSDictionary{
                    
                    // Use String Array to hold Dictionary keys and the dictionary for the jsonDictionary
                    self.mozJSONDictionary = jsonDictionary
                    // populate into database
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                } else {
                    // TODO: NO data received
                }
            }
        }
    }
    
    //MARK: UITableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mozArray.count

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        
        // Use key value pair result
        var key: AnyObject? = mozArray.objectAtIndex(indexPath.row)
        let value: AnyObject? = mozJSONDictionary?.valueForKey(key! as! String)
        
        key = URLMetrics.responseFields[key as! String]
        
        populateCell(cell, key: key, value: value)
        
        
        if (indexPath.row % 2 == 0) {
            
            cell.backgroundColor = UIColor(red:30/255, green:144/255, blue:255/255, alpha:1.0)
        }
        else{
            cell.backgroundColor = UIColor(red:255/255, green:102/255, blue:102/255, alpha:1.0)
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
        }
     
        return cell
    }
    
    func populateCell(cell: UITableViewCell, key: AnyObject?, value: AnyObject?){
        if let valueString = value as? String {
            cell.textLabel!.text = "\(key as! String): \(valueString)"
        } else if let valueNumber = value as? NSNumber {
            cell.textLabel!.text = "\(key as! String): \(valueNumber.stringValue)"
        }
        
    }
    
    @IBAction func saveResult(sender: AnyObject) {
        if nil == mozJSONDictionary{
            let alert = UIAlertView()
            alert.title = "You must first perform a search"
            alert.addButtonWithTitle("okay")
            alert.show()
            return
        }
        
        // 1 Create ManagedObject
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let mozResult = NSEntityDescription.insertNewObjectForEntityForName("MozResult", inManagedObjectContext: managedContext) as! MozResult
        
        //2 populate object
        mozResult.canonicalURL = mozJSONDictionary?.valueForKey(ResponseField.uu.rawValue as String) as! String
        mozResult.mozRank = mozJSONDictionary?.valueForKey(ResponseField.umrp.rawValue as String) as! NSNumber
        mozResult.pageAuthority = mozJSONDictionary?.valueForKey(ResponseField.upa.rawValue as String) as! NSNumber
        mozResult.domainAuthority = mozJSONDictionary?.valueForKey(ResponseField.pda.rawValue as String) as! NSNumber
        mozResult.externalLinks = mozJSONDictionary?.valueForKey(ResponseField.ueid.rawValue as String) as! NSNumber
        
        // 3 save the nsmanagedobject
        var error: NSError?
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
        
    }
    
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        searchBar.hidden = true
        activityIndicator.startAnimating()
        
        
        if let url = NSURL(string: searchBar.text!){
            // 1. validate url
            if (searchBar.text! == "" || !UIApplication.sharedApplication().canOpenURL(url)) {
                let alert = UIAlertView()
                alert.title = "You must enter a well formed URL to lookup!"
                alert.addButtonWithTitle("Okay")
                alert.show()
                
                searchBar.hidden = false
                activityIndicator.stopAnimating()
                
                return
            }
            // 2. Perform lookup
            getMozData(searchBar.text!)
        }
        
        
        // 3. Wrap up
        searchBar.hidden = false
        activityIndicator.stopAnimating()

    }
    
}