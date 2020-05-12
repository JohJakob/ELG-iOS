//
//  SettingsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 13/08/2016
//  © Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class SettingsViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  // MARK: - Properties
  
  var defaults: UserDefaults!
	var grade = Int()
	var gradePickerView = ActionSheetPresentationControllerPickerViewController()
	var startView = Int()
	var startViewPickerView = ActionSheetPresentationControllerPickerViewController()
  var autoSave = Bool()
  var autoSaveSwitch = UISwitch()
	let grades = ["Keine Klasse", "5a", "5b", "5c", "5d", "5e", "6a", "6b", "6c", "6d", "6e", "7a", "7b", "7c", "7d", "7e", "8a", "8b", "8c", "8d", "8e", "9a", "9b", "9c", "9d", "9e", "10a", "10b", "10c", "10d", "10e", "11a", "11b", "11c", "11d", "11e", "12a", "12b", "12c", "12d", "12e"]
	let startViews = ["News", "Stundenplan", "Vertretungsplan"]
	var selectedPickerViewDataSource = 0
  
  // Use when online schedules are available again
  
  /* let loginViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("LoginTableViewController") */
  let editScheduleViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditScheduleTableViewController")
  let teacherModeViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeacherModeTableViewController")
	let aboutViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AboutTableViewController")
	
	// MARK: - UITableViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
		
		defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
		
		// Retrieve user defaults
		
		retrieveUserDefaults()
		
    // Initialize switches
    
    initSwitches()
  }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
  // MARK: - UITableView
  
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
		if indexPath.section == 0 {
			if indexPath.row == 0 {
				let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsDetailTableViewCell", for: indexPath)
				
				cell.textLabel!.text = "Klasse"
				cell.detailTextLabel!.text = grades[grade]
				
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
			let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsDetailTableViewCell", for: indexPath)
			
			cell.textLabel!.text = "Startseite"
			cell.detailTextLabel!.text = startViews[startView]
			
			return cell
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
				selectedPickerViewDataSource = 0
				
				let pickerViewController = ActionSheetPresentationControllerPickerViewController()
				
				pickerViewController.pickerView.delegate = self
				
				pickerViewController.pickerView.selectRow(grade, inComponent: 0, animated: false)
				
				present(pickerViewController, animated: true, completion: nil)
				
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
			selectedPickerViewDataSource = 1
			
			let pickerViewController = ActionSheetPresentationControllerPickerViewController()
			
			pickerViewController.pickerView.delegate = self
			
			pickerViewController.pickerView.selectRow(startView, inComponent: 0, animated: false)
			
			present(pickerViewController, animated: true, completion: nil)
			
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
	
	// MARK: - UIPickerView
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		var numberOfRows = Int()
		
		if selectedPickerViewDataSource == 0 {
			numberOfRows = grades.count
		} else {
			numberOfRows = startViews.count
		}
		
		return numberOfRows
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		var titleForRow = String()
		
		if selectedPickerViewDataSource == 0 {
			titleForRow = grades[row]
		} else {
			titleForRow = startViews[row]
		}
		
		return titleForRow
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if selectedPickerViewDataSource == 0 {
			grade = row
			
			defaults.set(row, forKey: "grade")
		} else {
			startView = row
			
			defaults.set(row, forKey: "startView")
		}
		
		defaults.synchronize()
		
		tableView.reloadData()
	}
	
	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 35
	}
  
  // MARK: - Custom
	
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
    
		if #available(iOS 11, *) {
			autoSaveSwitch.onTintColor = UIColor(named: "AccentColor")
		} else {
			autoSaveSwitch.onTintColor = UIColor(red: 0.498, green: 0.09, blue: 0.204, alpha: 1)
		}
  }
  
  @objc func toggleAutoSave() {
    // Set user default
    
    if autoSaveSwitch.isOn {
      autoSave = true
    } else {
      autoSave = false
    }
    
    defaults.set(autoSave, forKey: "autoSave")
    defaults.synchronize()
  }
}
