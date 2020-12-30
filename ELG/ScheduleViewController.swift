//
//  ScheduleViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 26/06/2016
//  © Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class ScheduleViewController: UITableViewController {
  // MARK: - Properties
  
  var defaults: UserDefaults!
  var lessonsViewController = UIViewController()
	
	// MARK: - UITableViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
		
		if #available(iOS 11, *) {
			lessonsViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LessonsTableViewController")
		} else {
			lessonsViewController = UIStoryboard(name: "MainLegacy", bundle: Bundle.main).instantiateViewController(withIdentifier: "LessonsTableViewController")
		}
		
		defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
  }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if defaults.object(forKey: "selectedDay") != nil && defaults.integer(forKey: "startView") == 1 && defaults.bool(forKey: "didShowSchedule") == false {
			defaults.set(true, forKey: "didShowSchedule")
			defaults.synchronize()
			
			navigationController?.show(lessonsViewController, sender: self)
		}
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath)
    let days = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag"]
    
    cell.textLabel!.text = days[indexPath.row]
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
		
    defaults.set(indexPath.row, forKey: "selectedDay")
    defaults.synchronize()

		navigationController?.show(lessonsViewController, sender: self)
  }
}
