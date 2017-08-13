//
//  SettingsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 13/08/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class SettingsViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  // MARK: Variables + constants
  
  var defaults: UserDefaults!
	var pickerViewSource = 0
	var grade = Int()
	var startView = Int()
	var didTapGrade = false
	var didTapStartView = false
  var autoSave = Bool()
  var autoSaveSwitch = UISwitch()
	let grades = ["5a", "5b", "5c", "5d", "5e", "6a", "6b", "6c", "6d", "6e", "7a", "7b", "7c", "7d", "8a", "8b", "8c", "8d", "9a", "9b", "9c", "9d", "10a", "10b", "10c", "10d", "11a", "11b", "11c", "11d", "11e", "12a", "12b", "12c", "12d", "12e"]
	let startViews = ["Hauptmenü", "News", "Stundenplan", "Vertretungsplan", "Förderverein"]
  
  // Use when online schedules are available again
  
  /* let loginViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("LoginTableViewController") */
  // let editScheduleViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditScheduleTableViewController")
	let editScheduleViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditScheduleTableViewController") as! EditScheduleViewController
  let teacherModeViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeacherModeTableViewController")
	let aboutViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AboutTableViewController")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
		
		defaults = UserDefaults.init(suiteName: "group.com.hardykrause.elg")
		
		// Register custom table view cell
		
		tableView.register(UINib(nibName: "PickerTableViewCell", bundle: nil), forCellReuseIdentifier: "PickerTableViewCell")
		
		// Set back indicator image
		
		navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Back")
		navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Back")
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		
		// Retrieve user defaults
		
		retrieveUserDefaults()
		
    // Initialize switches
    
    initSwitches()
  }
  
  // MARK: Table view functions
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRows = Int()
    
    switch section {
    case 0:
      numberOfRows = 3
      
      // Use when online schedules are available again
      
      /* numberOfRows = 3 */
      break
    case 1:
      numberOfRows = 2
      break
    case 2:
      numberOfRows = 2
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
		if indexPath.section == 0 {
			if indexPath.row == 0 {
				let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsDetailTableViewCell", for: indexPath)
				
				cell.textLabel!.text = "Klasse"
				cell.detailTextLabel!.text = grades[grade]
				
				return cell
			} else if indexPath.row == 1 {
				let cell = tableView.dequeueReusableCell(withIdentifier: "PickerTableViewCell", for: indexPath) as! PickerTableViewCell
				
				cell.pickerView.delegate = self
				cell.pickerView.selectRow(grade, inComponent: 0, animated: false)
				
				pickerViewSource = 0
				
				return cell
			} else {
				let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath)
				
				cell.textLabel!.text = "Stundenplan bearbeiten"
				
				return cell
			}
		} else if indexPath.section == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath)
			
			switch indexPath.row {
			case 0:
				cell.textLabel!.text = "Automatisch sichern"
				cell.accessoryView = autoSaveSwitch
				cell.selectionStyle = .none
				break
			case 1:
				cell.textLabel!.text = "Lehrermodus"
				break
			default:
				break
			}
			
			return cell
		} else if indexPath.section == 2 {
			if indexPath.row == 0 {
				let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsDetailTableViewCell", for: indexPath)
				
				cell.textLabel!.text = "Startseite"
				cell.detailTextLabel!.text = startViews[startView]
				
				return cell
			} else {
				let cell = tableView.dequeueReusableCell(withIdentifier: "PickerTableViewCell", for: indexPath) as! PickerTableViewCell
				
				cell.pickerView.delegate = self
				cell.pickerView.selectRow(startView, inComponent: 0, animated: false)
				
				pickerViewSource = 1
				
				return cell
			}
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath)
			
			cell.textLabel!.text = "Über ELG"
			
			return cell
		}
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Deselect table view cell
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    // Check selected cell and navigate to new view based on selection
    
    switch indexPath.section {
    case 0:
      switch indexPath.row {
      case 0:
				pickerViewSource = 0
				didTapGrade = !didTapGrade
        break
      case 2:
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
			if indexPath.row == 0 {
				pickerViewSource = 1
				didTapStartView = !didTapStartView
			}
			
      break
		case 3:
			navigationController?.show(aboutViewController, sender: self)
			break
    default:
      break
    }
		
		tableView.beginUpdates()
		tableView.endUpdates()
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
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		var heightForRow = CGFloat()
		
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 1:
				if didTapGrade {
					heightForRow = 216
				} else {
					heightForRow = 0
				}
				break
			default:
				heightForRow = 44
				break
			}
			break
		case 2:
			switch indexPath.row {
			case 1:
				if didTapStartView {
					heightForRow = 216
				} else {
					heightForRow = 0
				}
				break
			default:
				heightForRow = 44
				break
			}
			break
		default:
			heightForRow = 44
			break
		}
		
		return heightForRow
	}
	
	// MARK: Picker view functions
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		var numberOfRows = Int()
		
		if pickerViewSource == 0 {
			numberOfRows = grades.count
		} else {
			numberOfRows = startViews.count
		}
		
		return numberOfRows
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if pickerViewSource == 0 {
			return grades[row]
		} else {
			return startViews[row]
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		// Set user defaults
		
		if pickerViewSource == 0 {
			grade = row
			
			defaults.set(grade, forKey: "grade")
		} else {
			startView = row
			
			defaults.set(startView, forKey: "startView")
		}
		
		defaults.synchronize()
		
		// Reload table view
		
		tableView.reloadData()
	}
  
  // MARK: Custom functions
	
	func retrieveUserDefaults() {
		// Retrieve user defaults
		
		grade = defaults.integer(forKey: "grade")
		autoSave = defaults.bool(forKey: "autoSave")
		startView = defaults.integer(forKey: "startView")
	}
	
  func initSwitches() {
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
