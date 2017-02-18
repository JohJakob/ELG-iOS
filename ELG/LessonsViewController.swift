//
//  LessonsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 26/06/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class LessonsViewController: UITableViewController {
  // Variables + constants
  
  var defaults: UserDefaults!
  var lessons: [String]!
  let editLessonsViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditLessonsTableViewController")
  
  // Actions
  
  @IBAction func editButtonTap(_ sender: UIBarButtonItem) {
		navigationController?.show(editLessonsViewController, sender: self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
		
		defaults = UserDefaults.init(suiteName: "group.com.hardykrause.elg")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Check selected day to retrieve lessons and set navigation bar title
    
    switch defaults.integer(forKey: "selectedDay") {
    case 0:
      lessons = defaults.stringArray(forKey: "monday")
      navigationItem.title = "Montag"
      break
    case 1:
      lessons = defaults.stringArray(forKey: "tuesday")
      navigationItem.title = "Dienstag"
      break
    case 2:
      lessons = defaults.stringArray(forKey: "wednesday")
      navigationItem.title = "Mittwoch"
      break
    case 3:
      lessons = defaults.stringArray(forKey: "thursday")
      navigationItem.title = "Donnerstag"
      break
    case 4:
      lessons = defaults.stringArray(forKey: "friday")
      navigationItem.title = "Freitag"
      break
    default:
      break
    }
    
    // Clear background view
    
    tableView.backgroundView = nil
    
    // Reload table view
    
    tableView.reloadData()
  }
  
  // Table view functions
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Check schedule for empty lessons at the end to shorten the table view
    
    var numberOfRows = Int()
    
    if lessons == nil {
      numberOfRows = 0
    } else {
      numberOfRows = lessons.count
      
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
    }
    
    // Set label as background view if there are no cells
    
    if numberOfRows == 0 {
      let noScheduleLabel = UILabel.init()
      noScheduleLabel.text = "Keine Stunden eingetragen"
      noScheduleLabel.textColor = UIColor.lightGray
      noScheduleLabel.font = UIFont.systemFont(ofSize: 16)
      noScheduleLabel.textAlignment = .center
      
      tableView.backgroundView = noScheduleLabel
    }
    
    return numberOfRows
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Set table view cell's text
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "LessonsTableViewCell", for: indexPath)
    
    cell.textLabel!.text = lessons[indexPath.row]
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Deselect table view cell
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
