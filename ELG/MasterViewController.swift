//
//  MasterViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 24/06/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class MasterViewController: UITableViewController {
  // Variables + constants
  
  // var startViewController: StartViewController? = nil
  var defaults: NSUserDefaults!
  var startView = Int()
  let introductionViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("IntroductionNavigationController")
  let startViewControllers = ["NewsNavigationController", "ScheduleNavigationController", "OmissionsNavigationController", "FoerdervereinNavigationController"]
  let lessonsViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("LessonsTableViewController")
  let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
  
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
    
    // Remove temporary user defaults
    
    removeUserDefaults()
    
    /* if let split = self.splitViewController {
     let controllers = split.viewControllers
     self.startViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? StartViewController
     } */
    
    // Show start view
    
    showStartView()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if #available(iOS 8, *) {
      self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    // Check first launch
    
    if (defaults.boolForKey("launched\(version)") != true) {
      // Show introduction
      
      showIntroduction()
    }
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
    
    // Set empty schedules in user defaults
    
    let emptySchedule = ["", "", "", "", "", "", "", "", "", ""]
    let emptyFridaySchedule = ["", "", "", "", "", ""]
    
    if defaults.stringArrayForKey("tuesday")?.count == 0 {
      defaults.setObject(emptySchedule, forKey: "monday")
    }
    
    if defaults.stringArrayForKey("tuesday")?.count == 0 {
      defaults.setObject(emptySchedule, forKey: "tuesday")
    }
    
    if defaults.stringArrayForKey("wednesday")?.count == 0 {
      defaults.setObject(emptySchedule, forKey: "wednesday")
    }
    
    if defaults.stringArrayForKey("thursday")?.count == 0 {
      defaults.setObject(emptySchedule, forKey: "thursday")
    }
    
    if defaults.stringArrayForKey("friday")?.count == 0 {
      defaults.setObject(emptyFridaySchedule, forKey: "friday")
    }
    
    // Set empty teacher token in user defaults
    
    if defaults.stringForKey("teacherToken") == nil {
      defaults.setObject("", forKey: "teacherToken")
    }
    
    // Synchronize user defaults
    
    defaults.synchronize()
  }
  
  func showIntroduction() {
    // Remove all user defaults
    
    defaults.removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
    
    // Set up app
    
    setUp()
    
    // Show release notes
    
    /* if #available(iOS 8, *) {
      navigationController?.showViewController(aboutWebViewController, sender: self)
    } else {
      navigationController?.pushViewController(aboutWebViewController, animated: true)
    } */
    
    presentViewController(introductionViewController, animated: true, completion: nil)
  }
  
  func showStartView() {
    // Get user default
    
    startView = defaults.integerForKey("startView")
    
    // Show start view based on user setting
    
    if startView != 0 {
      if startView == 2 {
        // Get current weekday
        
        let gregorianCalendar = NSCalendar.init(calendarIdentifier: NSGregorianCalendar)
        let dateComponents = gregorianCalendar!.components(.Weekday, fromDate: NSDate())
        
        // Check current weekday
        
        print(dateComponents.weekday)
        
        if dateComponents.weekday != 1 && dateComponents.weekday != 7 {
          // Set user default
          
          defaults.setInteger(dateComponents.weekday - 2, forKey: "selectedDay")
          defaults.synchronize()
          
          // Show start view
          
          if #available(iOS 8, *) {
            navigationController?.showDetailViewController(lessonsViewController, sender: self)
          }
        } else {
          // Set user default
          
          defaults.setInteger(0, forKey: "selectedDay")
          defaults.synchronize()
          
          // Show start view
          
          if #available(iOS 8, *) {
            navigationController?.showDetailViewController(lessonsViewController, sender: self)
          }
        }
      } else {
        // Show start view
        
        if #available(iOS 8, *) {
          navigationController?.showDetailViewController(UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(startViewControllers[startView - 1]), sender: self)
        }
      }
    }
  }
  
  func removeUserDefaults() {
    // Remove temporary user defaults
    
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
