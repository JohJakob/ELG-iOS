//
//  LessonsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 26/06/2016
//  © Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class LessonsViewController: UITableViewController {
  // MARK: - Properties
  
  var defaults: UserDefaults!
	var lessons = [String]()
	var rooms = [String]()
	let scheduleKeys = ["monday", "tuesday", "wednesday", "thursday", "friday"]
	let navigationItemTitle = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag"]
  var editLessonsViewController = UIViewController()
  
  @IBAction func editButtonTap(_ sender: UIBarButtonItem) {
		navigationController?.show(editLessonsViewController, sender: self)
  }
	
	// MARK: - UITableViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()
		
		if #available(iOS 11, *) {
			editLessonsViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditLessonsTableViewController")
		} else {
			editLessonsViewController = UIStoryboard(name: "MainLegacy", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditLessonsTableViewController")
		}
		
		defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
  }
	
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
		
		lessons = defaults.stringArray(forKey: scheduleKeys[defaults.integer(forKey: "selectedDay")]) ?? []
		rooms = defaults.stringArray(forKey: scheduleKeys[defaults.integer(forKey: "selectedDay")] + "Rooms") ?? []
		
		navigationItem.title = navigationItemTitle[defaults.integer(forKey: "selectedDay")]
    
    tableView.backgroundView = nil
    
    tableView.reloadData()
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
    var numberOfRows = Int()
    
		if lessons.count == 0 {
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
		
    if numberOfRows == 0 {
      let noScheduleLabel = UILabel.init()
      noScheduleLabel.text = "Keine Stunden eingetragen"
			
			if #available(iOS 13, *) {
				noScheduleLabel.textColor = .secondaryLabel
			} else {
				noScheduleLabel.textColor = .gray
			}
			
      noScheduleLabel.font = .boldSystemFont(ofSize: 18)
      noScheduleLabel.textAlignment = .center
      
      tableView.backgroundView = noScheduleLabel
    }
    
    return numberOfRows
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LessonsTableViewCell", for: indexPath)
    
    cell.textLabel!.text = lessons[indexPath.row]
		cell.detailTextLabel!.text = rooms[indexPath.row]
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
