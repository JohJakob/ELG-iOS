//
//  MasterViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 24/06/2016
//  © 2016 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class MasterViewController: UITableViewController {
  // Variables + constants
  
  // var startViewController: StartViewController? = nil
  var defaults: NSUserDefaults!
  var startView = Int()
  let startViewControllers = ["NewsNavigationController", "ScheduleNavigationController", "OmissionsNavigationController", "FoerdervereinNavigationController"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
    
    if #available(iOS 8, *) {
      defaults = NSUserDefaults.standardUserDefaults()
    } else {
      defaults = NSUserDefaults.init(suiteName: "group.com.hardykrause.elg")
    }
    
    // Set up app
    
    setUp()
    
    /* if let split = self.splitViewController {
     let controllers = split.viewControllers
     self.startViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? StartViewController
     } */
    
    // Check first launch
    
    if (defaults.boolForKey("launched2.0") != true) {
      // Show introduction
      
      showIntroduction()
    }
    
    // Show start view
    
    showStartView()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if #available(iOS 8, *) {
      self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
    }
    
    // Remove temporary user defaults
    
    removeUserDefaults()
  }
  
  // Table view functions
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // Deselect table view cell
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  // Custom functions
  
  func setUp() {
    // Set back indicator image
    
    navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Back")
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Back")
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    
    // Set title view
    
    navigationItem.titleView = UIImageView.init(image: UIImage(named: "Schulkreuz"))
    
    // Set empty schedules
    
    let emptySchedule = ["", "", "", "", "", "", "", "", "", ""]
    let emptyFridaySchedule = ["", "", "", "", "", ""]
    
    if defaults.stringArrayForKey("monday") == nil {
      defaults.setObject(emptySchedule, forKey: "monday")
    }
    
    if defaults.stringArrayForKey("tuesday") == nil {
      defaults.setObject(emptySchedule, forKey: "tuesday")
    }
    
    if defaults.stringArrayForKey("wednesday") == nil {
      defaults.setObject(emptySchedule, forKey: "wednesday")
    }
    
    if defaults.stringArrayForKey("thursday") == nil {
      defaults.setObject(emptySchedule, forKey: "thursday")
    }
    
    if defaults.stringArrayForKey("friday") == nil {
      defaults.setObject(emptyFridaySchedule, forKey: "friday")
    }
    
    if defaults.stringForKey("teacherToken") == nil {
      defaults.setObject("", forKey: "teacherToken")
    }
    
    defaults.synchronize()
  }
  
  func showIntroduction() {
    // TODO: Introduction
  }
  
  func showStartView() {
    // Get user default
    
    startView = defaults.integerForKey("startView")
    
    // Show start view based on user setting
    
    if startView != 0 {
      if #available(iOS 8, *) {
        navigationController?.showDetailViewController(UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(startViewControllers[startView - 1]), sender: self)
      }
    }
  }
  
  func removeUserDefaults() {
    // Remove temporary user defaults
    
    defaults.removeObjectForKey("selectedDay")
    defaults.removeObjectForKey("selectedSubject")
    defaults.removeObjectForKey("selectedRoom")
    defaults.removeObjectForKey("selectedAboutWebView")
    defaults.synchronize()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
