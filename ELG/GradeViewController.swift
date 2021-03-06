//
//  GradeViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 14/08/2016
//  © Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class GradeViewController: UITableViewController {
  // MARK: - Properties
  
  var defaults: UserDefaults!
  var selectedGrade = NSInteger()
  let grades = ["5a", "5b", "5c", "5d", "5e", "6a", "6b", "6c", "6d", "6e", "7a", "7b", "7c", "7d", "7e", "8a", "8b", "8c", "8d", "9a", "9b", "9c", "9d", "10a", "10b", "10c", "10d", "11a", "11b", "11c", "11d", "11e", "12a", "12b", "12c", "12d", "12e"]

	// MARK: - UITableViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
		
		defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
    
    // Retrieve user defaults
    
    retrieveUserDefaults()
  }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
  // MARK: - UITableView
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRows = Int()
    
    if section == 0 {
      numberOfRows = 1
    } else {
      numberOfRows = grades.count
    }
    
    return numberOfRows
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "GradeTableViewCell", for: indexPath)
    
    // Set table view cell's text and accessory type
    
    if indexPath.section == 0 {
      cell.textLabel!.text = "Keine Klasse"
      
      if selectedGrade == indexPath.row {
        cell.accessoryType = .checkmark
      } else {
        cell.accessoryType = .none
      }
    } else {
      cell.textLabel!.text = grades[indexPath.row]
      
      if selectedGrade == indexPath.row + 1 {
        cell.accessoryType = .checkmark
      } else {
        cell.accessoryType = .none
      }
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Deselect table view cell
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    // Set user default
    
    if indexPath.section == 0 {
      selectedGrade = indexPath.row
    } else {
      selectedGrade = indexPath.row + 1
    }
    
    defaults.set(selectedGrade, forKey: "selectedGrade")
    defaults.synchronize()
    
    // Reload table view
    
    tableView.reloadData()
  }
  
  // MARK: - Custom
  
  func retrieveUserDefaults() {
    // Retrieve selected grade from user defaults
    
    selectedGrade = defaults.integer(forKey: "selectedGrade")
  }
}
