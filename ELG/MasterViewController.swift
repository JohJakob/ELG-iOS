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
  let newsViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("NewsNavigationController")
  let scheduleViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("ScheduleNavigationController")
  let omissionsViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("OmissionsNavigationController")
  let foerdervereinViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("FoerdervereinNavigationController")
  
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
    
    switch startView {
    case 1:
      if #available(iOS 8, *) {
        navigationController?.showDetailViewController(newsViewController, sender: self)
      } else {
        navigationController?.pushViewController(newsViewController, animated: true)
      }
      break
    case 2:
      if #available(iOS 8, *) {
        navigationController?.showDetailViewController(scheduleViewController, sender: self)
      } else {
        navigationController?.pushViewController(scheduleViewController, animated: true)
      }
      break
    case 3:
      if #available(iOS 8, *) {
        navigationController?.showDetailViewController(omissionsViewController, sender: self)
      } else {
        navigationController?.pushViewController(omissionsViewController, animated: true)
      }
      break
    case 4:
      if #available(iOS 8, *) {
        navigationController?.showDetailViewController(foerdervereinViewController, sender: self)
      } else {
        navigationController?.pushViewController(foerdervereinViewController, animated: true)
      }
      break
    default:
      break
    }
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
