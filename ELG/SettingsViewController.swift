//
//  SettingsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 13/08/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class SettingsViewController: UITableViewController {
  // Variables + constants
  
  var defaults: NSUserDefaults!
  var autoSave = Bool()
  var autoSaveSwitch = UISwitch()
  let gradeViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("GradeTableViewController")
  
  // Use when online schedules are available again
  
  /* let loginViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("LoginTableViewController") */
  let editScheduleViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("EditScheduleTableViewController")
  let teacherModeViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("TeacherModeTableViewController")
  let startViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("ChooseStartTableViewController")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
    
    if #available(iOS 8, *) {
      defaults = NSUserDefaults.standardUserDefaults()
    } else {
      defaults = NSUserDefaults.init(suiteName: "group.com.hardykrause.elg")
    }
    
    // Initialize switches
    
    initSwitches()
  }
  
  // Table view functions
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    var numberOfRows = Int()
    
    if #available(iOS 8, *) {
      numberOfRows = 3
    } else {
      numberOfRows = 2
    }
    
    return numberOfRows
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRows = Int()
    
    switch section {
    case 0:
      numberOfRows = 2
      
      // Use when online schedules are available again
      
      /* numberOfRows = 3 */
      break
    case 1:
      numberOfRows = 2
      break
    case 2:
      numberOfRows = 1
      break
    default:
      break
    }
    
    return numberOfRows
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("SettingsTableViewCell", forIndexPath: indexPath)
    
    switch indexPath.section {
    case 0:
      switch indexPath.row {
      case 0:
        cell.textLabel!.text = "Klasse auswählen"
        break
      case 1:
        cell.textLabel!.text = "Stundenplan bearbeiten"
        
        // Use when online schedules are available again
        
        /* cell.textLabel!.text = "Zugangsdaten" */
        break
      // Use when online schedules are available again
        
      /* case 2:
        cell.textLabel!.text = "Stundenplan bearbeiten"
        break */
      default:
        break
      }
      break
    case 1:
      switch indexPath.row {
      case 0:
        cell.textLabel!.text = "Automatisch sichern"
        cell.accessoryView = autoSaveSwitch
        cell.selectionStyle = .None
        break
      case 1:
        cell.textLabel!.text = "Lehrermodus"
      default:
        break
      }
      break
    case 2:
      cell.textLabel!.text = "Startseite auswählen"
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
    
    switch indexPath.section {
    case 0:
      switch indexPath.row {
      case 0:
        if #available(iOS 8, *) {
          navigationController?.showViewController(gradeViewController, sender: self)
        } else {
          navigationController?.pushViewController(gradeViewController, animated: true)
        }
        break
      case 1:
        if #available(iOS 8, *) {
          navigationController?.showViewController(editScheduleViewController, sender: self)
        } else {
          navigationController?.pushViewController(editScheduleViewController, animated: true)
        }
        
        // Use when online schedules are available again
        
        /* if #available(iOS 8, *) {
          navigationController?.showViewController(loginViewController, sender: self)
        } else {
          navigationController?.pushViewController(loginViewController, animated: true)
        } */
        break
      // Use when online schedules are available again
        
      /* case 2:
        if #available(iOS 8, *) {
          navigationController?.showViewController(editScheduleViewController, sender: self)
        } else {
          navigationController?.pushViewController(editScheduleViewController, animated: true)
        }
        break */
      default:
        break
      }
      break
    case 1:
      if indexPath.row == 1 {
        if #available(iOS 8, *) {
          navigationController?.showViewController(teacherModeViewController, sender: self)
        } else {
          navigationController?.pushViewController(teacherModeViewController, animated: true)
        }
      }
      break
    case 2:
      if #available(iOS 8, *) {
        navigationController?.showViewController(startViewController, sender: self)
      } else {
        navigationController?.pushViewController(startViewController, animated: true)
      }
      break
    default:
      break
    }
  }
  
  // Custom functions
  
  func initSwitches() {
    // Retrieve user defaults
    
    autoSave = defaults.boolForKey("autoSave")
    
    // Initialize switches
    
    autoSaveSwitch = UISwitch.init(frame: CGRectZero)
    
    if autoSave {
      autoSaveSwitch.setOn(true, animated: false)
    } else {
      autoSaveSwitch.setOn(false, animated: false)
    }
    
    autoSaveSwitch.addTarget(self, action: #selector(SettingsViewController.toggleAutoSave), forControlEvents: .ValueChanged)
    
    autoSaveSwitch.onTintColor = UIColor(red: 0.498, green: 0.09, blue: 0.203, alpha: 1)
  }
  
  func toggleAutoSave() {
    // Set user default
    
    if autoSaveSwitch.on {
      autoSave = true
    } else {
      autoSave = false
    }
    
    defaults.setBool(autoSave, forKey: "autoSave")
    defaults.synchronize()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
