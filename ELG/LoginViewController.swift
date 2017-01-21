//
//  LoginViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 14/08/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class LoginViewController: UITableViewController, UITextFieldDelegate {
  // Outlets
  
  @IBOutlet weak var loginButton: UIBarButtonItem!
  
  // Variables
  
  var defaults: NSUserDefaults!
  var username = String()
  var password = String()
  var token = String()
  
  // Actions
  
  @IBAction func loginButtonTap(sender: UIBarButtonItem) {
    // Find credentials from 1Password
    
    OnePasswordExtension.sharedExtension().findLoginForURLString("http://www.elg-halle.de", forViewController: self, sender: loginButton, completion: {(loginDictionary: Dictionary<NSObject, AnyObject>?, error: NSError?) in
      if loginDictionary!.count == 0 {
        if Int32(error!.code) != AppExtensionErrorCodeCancelledByUser {
          print("Error invoking 1Password App Extension for finding credentials:" + String(error!))
        }
        
        return
      }
      
      // Set variables
      
      self.username = "\(loginDictionary![AppExtensionUsernameKey]!)"
      self.password = "\(loginDictionary![AppExtensionPasswordKey]!)"
      
      // Reload table view
      
      self.tableView.reloadData()
    })
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
    
		defaults = NSUserDefaults.standardUserDefaults()
    
    // Register custom table view cell
    
    tableView.registerNib(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
    
    // Enable login button if password manager is installed
    
    loginButton.enabled = OnePasswordExtension.sharedExtension().isAppExtensionAvailable()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // Retrieve user defaults
    
    retrieveUserDefaults()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Set user defaults
    
    setUserDefaults()
  }
  
  // Table view functions
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRows = Int()
    
    if section == 0 {
      numberOfRows = 2
    } else {
      numberOfRows = 1
    }
    
    return numberOfRows
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell", forIndexPath: indexPath) as! TextFieldTableViewCell
    
    // Set text field's placeholder and text in table view cell
    
    if indexPath.section == 0 {
      if indexPath.row == 0 {
        cell.textField.placeholder = "Benutzername"
        cell.textField.text = username
        cell.textField.tag = 1
      } else {
        cell.textField.placeholder = "Passwort"
        cell.textField.text = password
        cell.textField.secureTextEntry = true
        cell.textField.keyboardType = .NumbersAndPunctuation
        cell.textField.keyboardAppearance = .Dark
        cell.textField.tag = 2
      }
    } else {
      cell.textField.placeholder = "Kürzel"
      cell.textField.text = token
      cell.textField.autocapitalizationType = .Words
      cell.textField.tag = 3
    }
    
    // Set text field's delegate
    
    cell.textField.delegate = self
    
    return cell
  }
  
  // Text field functions
  
  func textFieldDidEndEditing(textField: UITextField) {
    // Check text field tag and set variables
    
    switch textField.tag {
    case 1:
      username = textField.text!
      break
    case 2:
      password = textField.text!
      break
    case 3:
      token = textField.text!
      break
    default:
      break
    }
    
    // Resign first responder
    
    textField.resignFirstResponder()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    // Resign first responder
    
    textField.resignFirstResponder()
    
    return true
  }
  
  // Custom functions
  
  func retrieveUserDefaults() {
    // Retrieve user defaults
    
    username = defaults.stringForKey("username")!
    password = defaults.stringForKey("password")!
    token = defaults.stringForKey("token")!
  }
  
  func setUserDefaults() {
    // Set user defaults
    
    defaults.setValue(username, forKey: "username")
    defaults.setValue(password, forKey: "password")
    defaults.setValue(token, forKey: "token")
    defaults.synchronize()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
