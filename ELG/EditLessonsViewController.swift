//
//  EditLessonsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 12/07/2016
//  © Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class EditLessonsViewController: UITableViewController, SubjectsViewControllerDelegate {
  // MARK: - Properties
  
  var defaults: UserDefaults!
  var lessons: [String]!
	var rooms: [String]!
  var subjectsViewController = SubjectsViewController()
	let weekdays = ["monday", "tuesday", "wednesday", "thursday", "friday"]
	let weekdayTitles = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag"]
	
	// MARK: - UITableViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
		
		if #available(iOS 11, *) {
			subjectsViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SubjectsTableViewController") as! SubjectsViewController
		} else {
			subjectsViewController = UIStoryboard(name: "MainLegacy", bundle: Bundle.main).instantiateViewController(withIdentifier: "SubjectsTableViewController") as! SubjectsViewController
		}
		
		// Set subjects view controller delegate
		subjectsViewController.delegate = self
    
    // Initialize user defaults
		
		defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
  }
	
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
		updateLessons()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Remove temporary user defaults
    
    removeUserDefaults()
  }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
  // MARK: - UITableView
  
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
  
	// TODO: Refactor
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "EditLessonsTableViewCell", for: indexPath)
    
		// If table view cell is selected cell and selected subject is not nil
    if defaults.integer(forKey: "selectedLesson") == indexPath.row && defaults.string(forKey: "selectedSubject") != nil {
			// If selected subject is “No Lesson”
      if defaults.string(forKey: "selectedSubject") == "Kein Unterricht" {
        cell.textLabel!.text = String(indexPath.row + 1) + ". Stunde"
				cell.detailTextLabel!.text = ""
        
        lessons[indexPath.row] = ""
				rooms[indexPath.row] = ""
      } else {
				// If no room was set
        if defaults.string(forKey: "selectedRoom") == "" {
          cell.textLabel!.text = defaults.string(forKey: "selectedSubject")
					cell.detailTextLabel!.text = ""
          
          lessons[indexPath.row] = defaults.string(forKey: "selectedSubject")!
					rooms[indexPath.row] = ""
        } else {
          cell.textLabel!.text = defaults.string(forKey: "selectedSubject")!
					cell.detailTextLabel!.text = defaults.string(forKey: "selectedRoom")
          
					lessons[indexPath.row] = defaults.string(forKey: "selectedSubject") ?? ""
					rooms[indexPath.row] = defaults.string(forKey: "selectedRoom") ?? ""
        }
      }
    } else {
      if lessons[indexPath.row] == "" {
        cell.textLabel!.text = String(indexPath.row + 1) + ". Stunde"
				cell.detailTextLabel!.text = ""
      } else {
        cell.textLabel!.text = lessons[indexPath.row]
				cell.detailTextLabel!.text = rooms[indexPath.row]
      }
    }
    
    // Save lessons in user defaults
    saveLessons()
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Deselect table view cell
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    // Set user default
    
    defaults.set(indexPath.row, forKey: "selectedLesson")
    defaults.synchronize()
		
		//navigationController?.show(subjectsViewController, sender: self)
		
		// Create navigation controller for subject list view
		let subjectsNavigationController = UINavigationController(rootViewController: subjectsViewController)
		
		// Set tint color of subject navigation controller
		if #available(iOS 11, *) {
			subjectsNavigationController.navigationBar.tintColor = UIColor(named: "AccentColor")
		} else {
			subjectsNavigationController.navigationBar.tintColor = UIColor.init(red: 0.498, green: 0.09, blue: 0.204, alpha: 1)
		}
		
		// Present subject navigation controller
		present(subjectsNavigationController, animated: true, completion: nil)
  }
	
	// MARK: - SubjectsViewControllerDelegate
	
	func didDismissViewController(viewController: UIViewController) {
		updateLessons()
	}
  
  // MARK: - Custom
  
  func removeUserDefaults() {
    // Remove temporary user defaults
    
    defaults.removeObject(forKey: "selectedSubject")
    defaults.removeObject(forKey: "selectedRoom")
    defaults.synchronize()
  }
	
	///
	/// Update lessons and rooms based on selected day
	///
	func updateLessons() {
		// Get lessons and rooms for selected day
		if defaults.object(forKey: weekdays[defaults.integer(forKey: "selectedDay")]) != nil {
			lessons = defaults.stringArray(forKey: weekdays[defaults.integer(forKey: "selectedDay")])
			rooms = defaults.stringArray(forKey: weekdays[defaults.integer(forKey: "selectedDay")] + "Rooms")
		} else {
			// Create empty arrays if the schedule for the selected day returns nil
			if defaults.integer(forKey: "selectedDay") == 4 {
				lessons = [String](repeating: "", count: 6)
				rooms = [String](repeating: "", count: 6)
			} else {
				lessons = [String](repeating: "", count: 10)
				rooms = [String](repeating: "", count: 10)
			}
		}
		
		// Set navigation bar title for selected day
		navigationItem.title = weekdayTitles[defaults.integer(forKey: "selectedDay")]
    
    // Reload table view
    tableView.reloadData()
	}
  
	///
	/// Save lessons and rooms in user defaults
	///
  func saveLessons() {
		defaults.set(lessons, forKey: weekdays[defaults.integer(forKey: "selectedDay")])
		defaults.set(rooms, forKey: weekdays[defaults.integer(forKey: "selectedDay")] + "Rooms")
    
    defaults.synchronize()
  }
}
