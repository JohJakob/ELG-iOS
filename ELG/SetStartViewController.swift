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
  
  var defaults: UserDefaults!
  var startView = Int()
  let views = ["News", "Förderverein", "Stundenplan", "Vertretungsplan"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
    
		defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
  }
  
  // Table view functions
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return views.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SetStartTableViewCell", for: indexPath)
    
    // Set table view cell's text
    
    cell.textLabel!.text = views[indexPath.row]
    
    // Get current start view
    
    startView = defaults.integer(forKey: "startView")
    
    if indexPath.row == startView {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Deselect table view cell
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    // Set new start view
    
    startView = indexPath.row
    
    // Set user default
    
    defaults.set(startView, forKey: "startView")
    defaults.synchronize()
    
    // Reload table view
    
    tableView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
