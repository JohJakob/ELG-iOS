//
//  SettingsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 13/08/2016
//  ©2016 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class SettingsViewController: UITableViewController {
  // Variables
  
  var defaults: NSUserDefaults!
  var autoSave = Bool()
  var iCloudEnabled = Bool()
  var autoSaveSwitch = UISwitch()
  var iCloudSwitch = UISwitch()
  
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
    return 4
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRows = Int()
    
    switch section {
    case 0:
      numberOfRows = 3
      break
    case 1:
      numberOfRows = 2
      break
    case 2:
      numberOfRows = 1
      break
    case 3:
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
        cell.textLabel!.text = "Zugangsdaten"
        break
      case 2:
        cell.textLabel!.text = "Stundenplan bearbeiten"
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
    case 3:
      cell.textLabel!.text = "In iCloud sichern"
      cell.accessoryView = iCloudSwitch
      cell.selectionStyle = .None
      break
    default:
      break
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var titleForHeader = String()
    
    switch section {
    case 0:
      titleForHeader = "Allgemein"
      break
    case 1:
      titleForHeader = "Vertretungsplan"
      break
    case 2:
      titleForHeader = "Startseite"
      break
    case 3:
      titleForHeader = "Einstellungen"
      break
    default:
      break
    }
    
    return titleForHeader
  }
  
  // Custom functions
  
  func initSwitches() {
    // Retrieve user defaults
    
    autoSave = defaults.boolForKey("autoSave")
    iCloudEnabled = defaults.boolForKey("iCloudEnabled")
    
    // Initialize switches
    
    autoSaveSwitch = UISwitch.init(frame: CGRectZero)
    iCloudSwitch = UISwitch.init(frame: CGRectZero)
    
    if autoSave {
      autoSaveSwitch.setOn(true, animated: false)
    } else {
      autoSaveSwitch.setOn(false, animated: false)
    }
    
    if iCloudEnabled {
      iCloudSwitch.setOn(true, animated: false)
    } else {
      iCloudSwitch.setOn(false, animated: false)
    }
    
    autoSaveSwitch.addTarget(self, action: #selector(SettingsViewController.toggleAutoSave), forControlEvents: .ValueChanged)
    iCloudSwitch.addTarget(self, action: #selector(SettingsViewController.toggleiCloud), forControlEvents: .ValueChanged)
    
    autoSaveSwitch.onTintColor = UIColor(red: 0.498, green: 0.09, blue: 0.203, alpha: 1)
    iCloudSwitch.onTintColor = UIColor(red: 0.498, green: 0.09, blue: 0.203, alpha: 1)
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
  
  func toggleiCloud() {
    // Set user default
    
    if iCloudSwitch.on {
      iCloudEnabled = true
    } else {
      iCloudEnabled = false
    }
    
    defaults.setBool(iCloudEnabled, forKey: "iCloudEnabled")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
