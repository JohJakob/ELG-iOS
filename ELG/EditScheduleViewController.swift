//
//  EditScheduleViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 12/07/2016
//  © Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class EditScheduleViewController: UITableViewController {
  // MARK: - Properties
  
  var defaults: UserDefaults!
	
	// MARK: - UITableViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
		
		defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
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
    return 5
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "EditScheduleTableViewCell", for: indexPath)
    let days = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag"]
    
    // Set table view cell's text
    
    cell.textLabel!.text = days[indexPath.row];
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Deselect table view cell
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    // Set user default
    
    defaults.set(indexPath.row, forKey: "selectedDay")
    defaults.synchronize()
    
    // Show new view
		
		var editLessonsViewController = UIViewController()
		
		if #available(iOS 11, *) {
			editLessonsViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditLessonsTableViewController") as! EditLessonsViewController
		} else {
			editLessonsViewController = UIStoryboard(name: "MainLegacy", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditLessonsTableViewController") as! EditLessonsViewController
		}
		
		navigationController?.show(editLessonsViewController, sender: self)
  }
}
