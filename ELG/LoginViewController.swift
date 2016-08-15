//
//  LoginViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 14/08/2016
//  ©2016 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class LoginViewController: UITableViewController {
  // Variables
  
  var defaults: NSUserDefaults!
  var username = String()
  var password = String()
  var token = String()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
    
    if #available(iOS 8, *) {
      defaults = NSUserDefaults.standardUserDefaults()
    } else {
      defaults = NSUserDefaults.init(suiteName: "group.com.hardykrause.elg")
    }
    
    // Register custom table view cell
    
    tableView.registerNib(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // Retrieve user defaults
    
    retrieveUserDefaults()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Get table view cells
    
    let usernameTableViewCell = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! TextFieldTableViewCell
    let passwordTableViewCell = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell", forIndexPath: NSIndexPath(forRow: 1, inSection: 0)) as! TextFieldTableViewCell
    let tokenTableViewCell = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 1)) as! TextFieldTableViewCell
    
    // Set user defaults
    
    defaults.setValue(usernameTableViewCell.textField.text, forKey: "username")
    defaults.setValue(passwordTableViewCell.textField.text, forKey: "password")
    defaults.setValue(tokenTableViewCell.textField.text, forKey: "token")
    defaults.synchronize()
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
    
    // Set text field's placeholder and text in cell
    
    if indexPath.section == 0 {
      if indexPath.row == 0 {
        cell.textField.placeholder = "Benutzername"
        cell.textField.text = username
        cell.textField.returnKeyType = .Done
      } else {
        cell.textField.placeholder = "Passwort"
        cell.textField.text = password
        cell.textField.secureTextEntry = true
        cell.textField.keyboardType = .NumbersAndPunctuation
        cell.textField.returnKeyType = .Done
      }
    } else {
      cell.textField.placeholder = "Kürzel"
      cell.textField.text = token
      cell.textField.returnKeyType = .Done
    }
    
    return cell
  }
  
  // Custom functions
  
  func retrieveUserDefaults() {
    // Retrieve user defaults
    
    username = defaults.stringForKey("username")!
    password = defaults.stringForKey("password")!
    token = defaults.stringForKey("token")!
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
