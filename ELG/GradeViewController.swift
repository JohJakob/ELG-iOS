//
//  GradeViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 14/08/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class GradeViewController: UITableViewController {
  // Variables + constants
  
  var defaults: NSUserDefaults!
  var selectedGrade = NSInteger()
  let grades = ["5a", "5b", "5c", "5d", "5e", "6a", "6b", "6c", "6d", "6e", "7a", "7b", "7c", "7d", "8a", "8b", "8c", "8d", "9a", "9b", "9c", "9d", "10a", "10b", "10c", "10d", "11a", "11b", "11c", "11d", "11e", "12a", "12b", "12c", "12d", "12e"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
		
		defaults = NSUserDefaults.standardUserDefaults()
    
    // Retrieve user defaults
    
    retrieveUserDefaults()
  }
  
  // Table view functions
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRows = Int()
    
    if section == 0 {
      numberOfRows = 1
    } else {
      numberOfRows = grades.count
    }
    
    return numberOfRows
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("GradeTableViewCell", forIndexPath: indexPath)
    
    // Set table view cell's text and accessory type
    
    if indexPath.section == 0 {
      cell.textLabel!.text = "Keine Klasse"
      
      if selectedGrade == indexPath.row {
        cell.accessoryType = .Checkmark
      } else {
        cell.accessoryType = .None
      }
    } else {
      cell.textLabel!.text = grades[indexPath.row]
      
      if selectedGrade == indexPath.row + 1 {
        cell.accessoryType = .Checkmark
      } else {
        cell.accessoryType = .None
      }
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // Deselect table view cell
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    // Set user default
    
    if indexPath.section == 0 {
      selectedGrade = indexPath.row
    } else {
      selectedGrade = indexPath.row + 1
    }
    
    defaults.setInteger(selectedGrade, forKey: "selectedGrade")
    defaults.synchronize()
    
    // Reload table view
    
    tableView.reloadData()
  }
  
  // Custom functions
  
  func retrieveUserDefaults() {
    // Retrieve selected grade from user defaults
    
    selectedGrade = defaults.integerForKey("selectedGrade")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
