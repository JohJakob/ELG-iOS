//
//  SetStartViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 20/11/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class SetStartViewController: UITableViewController {
  // Variables + constants
  
  var defaults: NSUserDefaults!
  var startView = Int()
  let views = ["Hauptmenü", "News", "Stundenplan", "Vertretungsplan", "Förderverein"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
    
		defaults = NSUserDefaults.standardUserDefaults()
  }
  
  // Table view functions
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return views.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("SetStartTableViewCell", forIndexPath: indexPath)
    
    // Set table view cell's text
    
    cell.textLabel!.text = views[indexPath.row]
    
    // Get current start view
    
    startView = defaults.integerForKey("startView")
    
    if indexPath.row == startView {
      cell.accessoryType = .Checkmark
    } else {
      cell.accessoryType = .None
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // Deselect table view cell
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    // Set new start view
    
    startView = indexPath.row
    
    // Set user default
    
    defaults.setInteger(startView, forKey: "startView")
    defaults.synchronize()
    
    // Reload table view
    
    tableView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
