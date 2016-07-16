//
//  LessonsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 26/06/2016
//  ©2016 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class LessonsViewController: UITableViewController {
  // Variables + constants
  
  var defaults: NSUserDefaults!
  var lessons: [String]!
  let editLessonsViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("EditLessonsTableViewController")
  
  // Actions
  
  @IBAction func edit(sender: UIBarButtonItem) {
    navigationController?.pushViewController(editLessonsViewController, animated: true)
  }
  
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
    
    // Check selected day to retrieve lessons
    
    switch defaults.integerForKey("selectedDay") {
    case 0:
      lessons = defaults.stringArrayForKey("monday")
      break
    case 1:
      lessons = defaults.stringArrayForKey("tuesday")
      break
    case 2:
      lessons = defaults.stringArrayForKey("wednesday")
      break
    case 3:
      lessons = defaults.stringArrayForKey("thursday")
      break
    case 4:
      lessons = defaults.stringArrayForKey("friday")
      break
    default:
      break
    }
    
    // Reload table view
    
    tableView.reloadData()
  }
  
  // Table view functions
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Check schedule for empty lessons at the end to shorten the table view
    
    var numberOfRows = lessons.count
    var followingEmpty = true
    
    for i in 0 ..< lessons.count {
      followingEmpty = true
      
      if lessons[i] == "" {
        for n in i + 1 ..< lessons.count {
          if lessons[n] != "" {
            followingEmpty = false
          }
        }
        
        if followingEmpty {
          numberOfRows = lessons.count - (lessons.count - i)
          break
        }
      }
    }
    
    return numberOfRows
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    // Set table view cell's text
    
    let cell = tableView.dequeueReusableCellWithIdentifier("LessonsTableViewCell", forIndexPath: indexPath)
    
    cell.textLabel!.text = lessons[indexPath.row]
    
    return cell
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
