//
//  DetailViewController.swift
//  MozAnalytics
//
//  Created by Siess, Clement on 9/22/15.
//  Copyright (c) 2015 Siess, Clement. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var detailTableView: UITableView!
    
    var mozResult: MozResult?
    var mozArray: NSArray? = ResponseField.stringValues
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        detailTableView.dataSource = self
        detailTableView.reloadData()
    }
    
    
    //MARK UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mozArray!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.detailTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        
        var key: AnyObject? = mozArray?.objectAtIndex(indexPath.row)
        let value: AnyObject? = mozResult?.valueForKey(key! as! String)
        
        key = URLMetrics.responseFields[key as! String]
        
        populateCell(cell, key: key, value: value)
        
        return cell
    }
    
    func populateCell(cell: UITableViewCell, key: AnyObject?, value: AnyObject?){
        if let valueString = value as? String {
            cell.textLabel!.text = "\(key as! String): \(valueString)"
        } else if let valueNumber = value as? NSNumber {
            cell.textLabel!.text = "\(key as! String): \(valueNumber.stringValue)"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func refreshButton(sender: AnyObject) {
        
        detailTableView.reloadData()
        
    }
    
    
    
}
