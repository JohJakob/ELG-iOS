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
  let lessonsViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LessonsTableViewController")
  
  // Use when online schedule are available again
  
  /* let webScheduleViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("WebScheduleViewController") */
	
	// MARK: - UITableViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
		
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
    
    // Use when online schedule are available again
    
    /* return 2 */
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
    
    // Use when online schedules are available again
    
    /* var numberOfRows: Int
    
    if section == 0 {
      numberOfRows = 5
    } else {
      numberOfRows = 1
    }
    
    return numberOfRows */
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath)
    let days = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag"]
    
    cell.textLabel!.text = days[indexPath.row]
    
    // Use when online schedules are available again
    
    /* switch indexPath.section {
    case 0:
      cell.textLabel!.text = days[indexPath.row];
      break
    case 1:
      cell.textLabel!.text = "Stundenplan (Web)"
      break
    default:
      break
    } */
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
		
    defaults.set(indexPath.row, forKey: "selectedDay")
    defaults.synchronize()

		navigationController?.show(lessonsViewController, sender: self)
    
    // Use when online schedules are available again
    
    /* if indexPath.section == 0 {
      defaults.setInteger(indexPath.row, forKey: "selectedDay")
      defaults.synchronize()
		
			navigationController?.showViewController(lessonsViewController, sender: self)
    } else {
			navigationController?.showViewController(webScheduleViewController, sender: self)
    } */
  }
}
