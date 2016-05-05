//
//  ViewController.swift
//  MozAnalytics
//
//  Created by Siess, Clement on 9/10/15.
//  Copyright (c) 2015 Siess, Clement. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var accessIDTextField: UITextField!
    
    @IBOutlet weak var secretKeyTextField: UITextField!
    
    
    @IBOutlet weak var saveButton: UIButton!
    
//    let saveTag = 0
//    let updateTag = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.restorationIdentifier = "Settings"
        
        accessIDTextField.delegate = self
        secretKeyTextField.delegate = self
        
        if NSUserDefaults.standardUserDefaults().boolForKey("hasCredentials"){
            accessIDTextField.text = NSUserDefaults.standardUserDefaults().valueForKey("accessID") as? String
            secretKeyTextField.text = NSUserDefaults.standardUserDefaults().valueForKey("secretKey") as? String
            saveButton.setTitle("Update Settings", forState: .Normal)
        }
    }

    @IBAction func saveSettings(sender: AnyObject) {
        
        //validate inputs
        if (accessIDTextField.text == "" || secretKeyTextField.text == ""){
            let alert = UIAlertView()
            alert.title = "You must enter both an ID and a secret ID"
            alert.addButtonWithTitle("Okay")
            alert.show()
            return
        }
        accessIDTextField.resignFirstResponder()
        secretKeyTextField.resignFirstResponder()
        
        // save the values
        NSUserDefaults.standardUserDefaults().setValue(accessIDTextField.text, forKey: "accessID")
        NSUserDefaults.standardUserDefaults().setValue(secretKeyTextField.text, forKey: "secretKey")
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasCredentials")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        saveButton.setTitle("Update Settings", forState: .Normal)
        //saveButton.tag = updateTag
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        coder.encodeObject(accessIDTextField.text, forKey: "accessID")
        coder.encodeObject(secretKeyTextField.text, forKey: "secretKey")
        super.encodeRestorableStateWithCoder(coder)
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        if let accessID = coder.decodeObjectForKey("accessID") as? String {
            accessIDTextField.text = accessID
        }
        if let secretKey = coder.decodeObjectForKey("secretKey") as? String {
            secretKeyTextField.text = secretKey
        }
        
        super.decodeRestorableStateWithCoder(coder)
    }

}

