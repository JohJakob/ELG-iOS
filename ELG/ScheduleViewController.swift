//
//  ScheduleViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 26/06/2016
//  © 2016 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class ScheduleViewController: UITableViewController {
  // Variables + constants
  
  var defaults: NSUserDefaults!
  let lessonsViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("LessonsTableViewController")
  let webScheduleViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("WebScheduleViewController")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
    
    if #available(iOS 8, *) {
      defaults = NSUserDefaults.standardUserDefaults()
    } else {
      defaults = NSUserDefaults.init(suiteName: "group.com.hardykrause.elg")
    }
  }
  
  // Table view functions
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRows: Int
    
    if section == 0 {
      numberOfRows = 5
    } else {
      numberOfRows = 1
    }
    
    return numberOfRows
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ScheduleTableViewCell", forIndexPath: indexPath)
    let days = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag"]
    
    // Set table view cell's text
    
    switch indexPath.section {
    case 0:
      cell.textLabel!.text = days[indexPath.row];
      break
    case 1:
      cell.textLabel!.text = "Stundenplan (Web)"
      break
    default:
      break
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // Deselect table view cell
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    // Check selected cell and navigate to new view based on selection
    
    if indexPath.section == 0 {
      defaults.setInteger(indexPath.row, forKey: "selectedDay")
      defaults.synchronize()
      
      if #available(iOS 8, *) {
        navigationController?.showViewController(lessonsViewController, sender: self)
      } else {
        navigationController?.pushViewController(lessonsViewController, animated: true)
      }
    } else {
      if #available(iOS 8, *) {
        navigationController?.showViewController(webScheduleViewController, sender: self)
      } else {
        navigationController?.pushViewController(webScheduleViewController, animated: true)
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
