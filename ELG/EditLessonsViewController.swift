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
  
  var defaults: UserDefaults!
  var lessons: [String]!
  let subjectsViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SubjectsTableViewController")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
		
		defaults = UserDefaults.standard
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
    
    if lessons == nil {
      switch defaults.integer(forKey: "selectedDay") {
      case 4:
        lessons = ["", "", "", "", "", ""]
        break;
      default:
        lessons = ["", "", "", "", "", "", "", "", "", ""]
        break
      }
    }
    
    // Reload table view
    
    tableView.reloadData()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Remove temporary user defaults
    
    removeUserDefaults()
  }
  
  // Table view functions
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRows: Int
    
    switch defaults.integer(forKey: "selectedDay") {
    case 4:
      numberOfRows = 6
      break
    default:
      numberOfRows = 10
    }
    
    return numberOfRows
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "EditLessonsTableViewCell", for: indexPath)
    
    // Check selected lesson, subject from subject list and set the table view cell's text
    
    if defaults.integer(forKey: "selectedLesson") == indexPath.row && defaults.string(forKey: "selectedSubject") != nil {
      if defaults.string(forKey: "selectedSubject") == "Kein Unterricht" {
        cell.textLabel!.text = String(indexPath.row + 1) + ". Stunde"
        
        lessons[indexPath.row] = ""
      } else {
        if defaults.string(forKey: "selectedRoom") == "" {
          cell.textLabel!.text = defaults.string(forKey: "selectedSubject")
          
          lessons[indexPath.row] = defaults.string(forKey: "selectedSubject")!
        } else {
          cell.textLabel!.text = defaults.string(forKey: "selectedSubject")! + " (" + defaults.string(forKey: "selectedRoom")! + ")"
          
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
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Deselect table view cell
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    // Set user default
    
    defaults.set(indexPath.row, forKey: "selectedLesson")
    defaults.synchronize()
    
    // Show new view
		
		navigationController?.show(subjectsViewController, sender: self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
  
  // Custom functions
  
  func removeUserDefaults() {
    // Remove temporary user defaults
    
    defaults.removeObject(forKey: "selectedSubject")
    defaults.removeObject(forKey: "selectedRoom")
    defaults.synchronize()
  }
  
  func saveLessons() {
    // Save lessons in user defaults
    
    switch defaults.integer(forKey: "selectedDay") {
    case 0:
      defaults.set(lessons, forKey: "monday")
      break
    case 1:
      defaults.set(lessons, forKey: "tuesday")
      break
    case 2:
      defaults.set(lessons, forKey: "wednesday")
      break
    case 3:
      defaults.set(lessons, forKey: "thursday")
      break
    case 4:
      defaults.set(lessons, forKey: "friday")
      break
    default:
      break
    }
    
    defaults.synchronize()
  }
}
