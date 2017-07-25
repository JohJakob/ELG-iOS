//
//  SettingsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 13/08/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class SettingsViewController: UITableViewController {
  // Variables + constants
  
  var defaults: UserDefaults!
  var autoSave = Bool()
  var autoSaveSwitch = UISwitch()
  let gradeViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GradeTableViewController")
  
  // Use when online schedules are available again
  
  /* let loginViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("LoginTableViewController") */
  let editScheduleViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditScheduleTableViewController")
  let teacherModeViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeacherModeTableViewController")
  let startViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseStartTableViewController")
	let aboutViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AboutViewController")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
		
		defaults = UserDefaults.init(suiteName: "group.com.hardykrause.elg")
		
		// Set back indicator image
		
		navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Back")
		navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Back")
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		
    // Initialize switches
    
    initSwitches()
  }
  
  // Table view functions
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRows = Int()
    
    switch section {
    case 0:
      numberOfRows = 2
      
      // Use when online schedules are available again
      
      /* numberOfRows = 3 */
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
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath)
    
    switch indexPath.section {
    case 0:
      switch indexPath.row {
      case 0:
        cell.textLabel!.text = "Klasse auswählen"
        break
      case 1:
        cell.textLabel!.text = "Stundenplan bearbeiten"
        
        // Use when online schedules are available again
        
        /* cell.textLabel!.text = "Zugangsdaten" */
        break
      // Use when online schedules are available again
        
      /* case 2:
        cell.textLabel!.text = "Stundenplan bearbeiten"
        break */
      default:
        break
      }
      break
    case 1:
      switch indexPath.row {
      case 0:
        cell.textLabel!.text = "Automatisch sichern"
        cell.accessoryView = autoSaveSwitch
        cell.selectionStyle = .none
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
			cell.textLabel!.text = "Über ELG"
    default:
      break
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Deselect table view cell
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    // Check selected cell and navigate to new view based on selection
    
    switch indexPath.section {
    case 0:
      switch indexPath.row {
      case 0:
				navigationController?.show(gradeViewController, sender: self)
        break
      case 1:
				navigationController?.show(editScheduleViewController, sender: self)
        
        // Use when online schedules are available again
        
        /* navigationController?.showViewController(loginViewController, sender: self) */
        break
      // Use when online schedules are available again
        
      /* case 2:
				navigationController?.showViewController(editScheduleViewController, sender: self)
        break */
      default:
        break
      }
      break
    case 1:
      if indexPath.row == 1 {
				navigationController?.show(teacherModeViewController, sender: self)
      }
      break
    case 2:
			navigationController?.show(startViewController, sender: self)
      break
		case 3:
			navigationController?.show(aboutViewController, sender: self)
			break
    default:
      break
    }
  }
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		var titleForHeader = String()
		
		switch section {
		case 0:
			titleForHeader = "Allgemein"
			break
		case 1:
			titleForHeader = "Vertretungsplan"
			break
		default:
			titleForHeader = ""
			break
		}
		
		return titleForHeader
	}
  
  // Custom functions
  
  func initSwitches() {
    // Retrieve user defaults
    
    autoSave = defaults.bool(forKey: "autoSave")
    
    // Initialize switches
    
    autoSaveSwitch = UISwitch.init(frame: CGRect.zero)
    
    if autoSave {
      autoSaveSwitch.setOn(true, animated: false)
    } else {
      autoSaveSwitch.setOn(false, animated: false)
    }
    
    autoSaveSwitch.addTarget(self, action: #selector(SettingsViewController.toggleAutoSave), for: .valueChanged)
    
    autoSaveSwitch.onTintColor = UIColor(red: 0.498, green: 0.09, blue: 0.203, alpha: 1)
  }
  
  func toggleAutoSave() {
    // Set user default
    
    if autoSaveSwitch.isOn {
      autoSave = true
    } else {
      autoSave = false
    }
    
    defaults.set(autoSave, forKey: "autoSave")
    defaults.synchronize()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
