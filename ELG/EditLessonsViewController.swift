//
//  EditLessonsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 12/07/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class EditLessonsViewController: UITableViewController {
  // Variables + constants
  
  var defaults: NSUserDefaults!
  var lessons: [String]!
  let subjectsViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("SubjectsTableViewController")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
    
    if #available(iOS 8, *) {
      defaults = NSUserDefaults.standardUserDefaults()
    } else {
      defaults = NSUserDefaults.init(suiteName: "group.com.hardykrause.elg")
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // Check selected day to retrieve lessons and set navigation bar title
    
    switch defaults.integerForKey("selectedDay") {
    case 0:
      lessons = defaults.stringArrayForKey("monday")
      navigationItem.title = "Montag"
      break
    case 1:
      lessons = defaults.stringArrayForKey("tuesday")
      navigationItem.title = "Dienstag"
      break
    case 2:
      lessons = defaults.stringArrayForKey("wednesday")
      navigationItem.title = "Mittwoch"
      break
    case 3:
      lessons = defaults.stringArrayForKey("thursday")
      navigationItem.title = "Donnerstag"
      break
    case 4:
      lessons = defaults.stringArrayForKey("friday")
      navigationItem.title = "Freitag"
      break
    default:
      break
    }
    
    // Reload table view
    
    tableView.reloadData()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Remove temporary user defaults
    
    removeUserDefaults()
  }
  
  // Table view functions
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRows: Int
    
    switch defaults.integerForKey("selectedDay") {
    case 4:
      numberOfRows = 6
      break
    default:
      numberOfRows = 10
    }
    
    return numberOfRows
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("EditLessonsTableViewCell", forIndexPath: indexPath)
    
    // Check selected lesson, subject from subject list and set the table view cell's text
    
    if defaults.integerForKey("selectedLesson") == indexPath.row && defaults.stringForKey("selectedSubject") != nil {
      if defaults.stringForKey("selectedSubject") == "Kein Unterricht" {
        cell.textLabel!.text = String(indexPath.row + 1) + ". Stunde"
        
        lessons[indexPath.row] = ""
      } else {
        if defaults.stringForKey("selectedRoom") == "" {
          cell.textLabel!.text = defaults.stringForKey("selectedSubject")
          
          lessons[indexPath.row] = defaults.stringForKey("selectedSubject")!
        } else {
          cell.textLabel!.text = defaults.stringForKey("selectedSubject")! + " (" + defaults.stringForKey("selectedRoom")! + ")"
          
          lessons[indexPath.row] = cell.textLabel!.text!
        }
      }
    } else {
      if lessons[indexPath.row] == "" {
        cell.textLabel!.text = String(indexPath.row + 1) + ". Stunde"
      } else {
        cell.textLabel!.text = lessons[indexPath.row]
      }
    }
    
    // Save lessons
    
    saveLessons()
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // Deselect table view cell
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    // Set user default
    
    defaults.setInteger(indexPath.row, forKey: "selectedLesson")
    defaults.synchronize()
    
    // Navigate to new view
    
    if #available(iOS 8, *) {
      navigationController?.showViewController(subjectsViewController, sender: self)
    } else {
      navigationController?.pushViewController(subjectsViewController, animated: true)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
  
  // Custom functions
  
  func removeUserDefaults() {
    // Remove temporary user defaults
    
    defaults.removeObjectForKey("selectedSubject")
    defaults.removeObjectForKey("selectedRoom")
    defaults.synchronize()
  }
  
  func saveLessons() {
    // Save lessons in user defaults
    
    switch defaults.integerForKey("selectedDay") {
    case 0:
      defaults.setObject(lessons, forKey: "monday")
      break
    case 1:
      defaults.setObject(lessons, forKey: "tuesday")
      break
    case 2:
      defaults.setObject(lessons, forKey: "wednesday")
      break
    case 3:
      defaults.setObject(lessons, forKey: "thursday")
      break
    case 4:
      defaults.setObject(lessons, forKey: "friday")
      break
    default:
      break
    }
    
    defaults.synchronize()
  }
}
