//
//  MasterViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 24/06/2016
//  ©2016 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class MasterViewController: UITableViewController {
  // Variables
  
  // var startViewController: StartViewController? = nil
  var defaults: NSUserDefaults!
  
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
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if #available(iOS 8, *) {
      self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
    }
    
    // Remove temporary user defaults
    
    removeUserDefaults()
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
    
    defaults.synchronize()
  }
  
  func removeUserDefaults() {
    // Remove temporary user defaults
    
    defaults.removeObjectForKey("selectedDay")
    defaults.removeObjectForKey("selectedSubject")
    defaults.removeObjectForKey("selectedRoom")
    defaults.synchronize()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
