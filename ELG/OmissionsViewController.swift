//
//  OmissionsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 21/07/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class OmissionsViewController: UITableViewController {
  // MARK: - Properties
  
  @IBOutlet weak fileprivate var saveButton: UIBarButtonItem!
  
  var defaults: UserDefaults!
  var selectedGrade = Int()
  var rows = NSMutableArray()
  var ownOmissions = NSMutableArray()
  var offlineAvailable = Bool()
  var autoSave = Bool()
  var teacherMode = Bool()
  var teacherToken = String()
  let grades = ["Keine Klasse", "5a", "5b", "5c", "5d", "5e", "6a", "6b", "6c", "6d", "6e", "7a", "7b", "7c", "7d", "7e", "8a", "8b", "8c", "8d", "9a", "9b", "9c", "9d", "10a", "10b", "10c", "10d", "11a", "11b", "11c", "11d", "11e", "12a", "12b", "12c", "12d", "12e"]
  
  @IBAction func saveButtonTap(_ sender: UIBarButtonItem) {
    saveOmissions()
  }
	
	// MARK: - UITableViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()

		defaults = UserDefaults.init(suiteName: "group.com.hardykrause.elg")
    
    tableView.register(UINib(nibName: "OmissionsTableViewCell", bundle: nil), forCellReuseIdentifier: "OmissionsTableViewCell")
		
    let omissionsRefreshControl = UIRefreshControl.init()
    
    omissionsRefreshControl.addTarget(self, action: #selector(OmissionsViewController.refreshTableView), for: .valueChanged)
    
    refreshControl = omissionsRefreshControl

    getUserDefaults()
		
		// Retrieve offline omissions if available
		
		if offlineAvailable {
			getOfflineOmissions()
		} else {
			downloadOmissions()
		}
  }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
  // MARK: - UITableView
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    var numberOfSections: Int
    
    let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable || (reachabilityStatus == NotReachable && offlineAvailable) {
      numberOfSections = 2
    } else {
      numberOfSections = 0
      
      // Display label instead of table view
      
      let noConnectionLabel = UILabel.init()
      noConnectionLabel.text = "Keine Internetverbindung"
      noConnectionLabel.textColor = UIColor.lightGray
      noConnectionLabel.font = UIFont.systemFont(ofSize: 16)
      noConnectionLabel.textAlignment = .center
      
      tableView.backgroundColor = UIColor.groupTableViewBackground
      tableView.separatorStyle = .none
      tableView.backgroundView = noConnectionLabel
    }
    
    return numberOfSections
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRows: Int
    
    if section == 0 {
      numberOfRows = ownOmissions.count
    } else {
      if rows.count < 3 {
        numberOfRows = 0
      } else {
        numberOfRows = rows.count - 2
      }
    }
    
    return numberOfRows
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OmissionsTableViewCell", for: indexPath) as! OmissionsTableViewCell
    
    // Prepare omissions
    
    var omissionComponents: [String]
    
    if indexPath.section == 0 {
      omissionComponents = (ownOmissions[indexPath.row] as AnyObject).components(separatedBy: "\",\"")
    } else {
      omissionComponents = (rows[indexPath.row + 1] as AnyObject).components(separatedBy: "\",\"")
    }
    
    // Create omission components
    
    let grade = omissionComponents[0].replacingOccurrences(of: "\"", with: "")
    let lesson = omissionComponents[1]
    let teacher = omissionComponents[2]
    let subject = omissionComponents[3]
    let room = omissionComponents[4]
    let text = omissionComponents[5]
    let comment = omissionComponents[6].replacingOccurrences(of: "\"", with: "")
    
    // Set cell's text
    
    if grade.characters.count < 4 {
      cell.gradeLabel.text = grade
    } else {
      if grade.characters.first == "1" {
        cell.gradeLabel.text = grade.substring(to: grade.characters.index(grade.startIndex, offsetBy: 2))
      } else {
        cell.gradeLabel.text = grade.substring(to: grade.characters.index(grade.startIndex, offsetBy: 1))
      }
    }
    
    if subject == "" && teacher == "" {
      cell.lessonLabel.text = lesson + ". Stunde"
    } else if subject == "" {
      cell.lessonLabel.text = lesson + ". Stunde" + " (" + teacher + ")"
    } else if teacher == "" {
      cell.lessonLabel.text = lesson + ". Stunde" + ": " + subject
    } else {
      cell.lessonLabel.text = lesson + ". Stunde" + ": " + subject + " (" + teacher + ")"
    }
    
    if room == "" {
      cell.detailsLabel.text = text + "   " + comment
    } else {
      cell.detailsLabel.text = "Raum " + room + "   " + text + "   " + comment
    }
    
    // Remove unnecessary whitespaces
    
    cell.detailsLabel.text = cell.detailsLabel.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    
    cell.detailsLabel.text = cell.detailsLabel.text?.replacingOccurrences(of: "      ", with: "   ")
    
    // Change color of lesson label
    
    if comment == "Entfall" {
      cell.lessonLabel.textColor = UIColor(red: 0.498, green: 0.09, blue: 0.203, alpha: 1)
    } else {
      cell.lessonLabel.textColor = UIColor.black
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 65
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var titleForHeader: String
    
    if section == 0 {
      titleForHeader = "Eigene Vertretungen"
    } else {
      titleForHeader = "Alle Vertretungen"
    }
    
    return titleForHeader
  }
  
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footerLabel = UILabel()
    
    footerLabel.textColor = UIColor.lightGray
    footerLabel.font = UIFont.systemFont(ofSize: 16)
    footerLabel.textAlignment = .center
    
    if section == 0 {
      if ownOmissions.count == 0 {
        footerLabel.text = "Keine eigenen Vertretungen"
      } else {
        footerLabel.backgroundColor = UIColor.white
      }
    } else {
      if rows.count < 3 {
        footerLabel.text = "Keine Vertretungen"
      } else {
        footerLabel.backgroundColor = UIColor.white
      }
    }
    
    return footerLabel
  }
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    var heightForFooter: CGFloat = 0
    
    if section == 0 {
      if ownOmissions.count == 0 {
        heightForFooter = 44
      } else {
        heightForFooter = 0
      }
    } else {
      if rows.count < 3 {
        heightForFooter = 44
      } else {
        heightForFooter = 0
      }
    }
    
    return heightForFooter
  }
  
  // MARK: - Custom
  
  func getUserDefaults() {
    // Retrieve variables from user defaults
    
    selectedGrade = defaults.integer(forKey: "grade")
    offlineAvailable = defaults.bool(forKey: "offlineAvailable")
    autoSave = defaults.bool(forKey: "autoSave")
    teacherMode = defaults.bool(forKey: "teacherMode")
    teacherToken = defaults.string(forKey: "teacherToken")!
  }
  
  func refreshTableView() {
		// Update variables from UserDefaults
		
    getUserDefaults()
		
		downloadOmissions()
    
    tableView.reloadData()
    
    refreshControl?.endRefreshing()
  }
  
  func getOfflineOmissions() {
    // Retrieve offline omissions
    
    rows = defaults.mutableArrayValue(forKey: "offlineOmissions")
    ownOmissions = defaults.mutableArrayValue(forKey: "ownOfflineOmissions")
    
    // Set date
    
    navigationItem.title = rows[0] as? String
    
    // Disable save button
    
    saveButton.isEnabled = false
  }
  
  func downloadOmissions() {
    // Check internet reachability
    
    let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      // Download CSV file
      
      var rawOmissions = String()
      
      do {
        try rawOmissions = String(contentsOf: URL.init(string: "http://elg-halle.de/Aktuell/Intern/Vertretungsplan/vp.csv")!, encoding: String.Encoding.ascii)
      } catch {
        print(error)
      }
      
      // Convert raw data into array
      
      let cleanedOmissions = rawOmissions.replacingOccurrences(of: "\r", with: "")
      
      rows = NSMutableArray.init(array: cleanedOmissions.components(separatedBy: "\n"))
      
      // Reset own omissions
      
      ownOmissions = NSMutableArray()
      
      // Process array
      
      for i in 1 ..< rows.count - 1 {
        // Remove lunch break
        
        if (rows[i] as AnyObject).range(of: "MIPa").location != NSNotFound {
          rows.removeObject(at: i)
        }
        
        // Prepare getting own omissions
        
        let omissionComponents = (rows[i] as AnyObject).components(separatedBy: "\",\"")
        let grade = omissionComponents[0].replacingOccurrences(of: "\"", with: "")
        var teacher = String()
        
        // Get teacher of omission
        
        if omissionComponents.count >= 3 {
          teacher = omissionComponents[2]
        }
        
        // Check teacher mode or selected grade to get own omissions
        
        if teacherMode {
          if teacher == teacherToken && teacher != "" {
            ownOmissions.add(rows[i])
          }
        } else {
          if selectedGrade != 0 {
            if grade.range(of: grades[selectedGrade - 1]) != nil {
              ownOmissions.add(rows[i])
            }
          }
        }
      }
      
      // Set date
      
      navigationItem.title = rows[0] as? String
      
      // Reset table view appearance
      
      tableView.backgroundColor = UIColor.white
      tableView.separatorStyle = .singleLine
      
      // Set offline availability status
      
      offlineAvailable = false
      
      // Set user default
      
      defaults.set(offlineAvailable, forKey: "offlineAvailable")
      defaults.synchronize()
      
      // Enable/Disable save button
      
      if rows.count < 3 {
        saveButton.isEnabled = false
      } else {
        saveButton.isEnabled = true
      }
      
      if autoSave {
        saveOmissions()
      }
    } else {
      // Disable save button
      
      saveButton.isEnabled = false
      
      // Show alert
      
      let noConnectionAlert = UIAlertView(title: "Keine Internetverbindung", message: "Es besteht keine Verbindung zum Internet. Bitte überprüfe Deine Einstellungen.", delegate: self, cancelButtonTitle: "OK")
      noConnectionAlert.show()
      
      // Change table view appearance
      
      tableView.backgroundColor = UIColor.groupTableViewBackground
      tableView.separatorStyle = .none
    }
  }
  
  func saveOmissions() {
    // Check internet reachability
    
    let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      // Save omissions
      
      offlineAvailable = true
      
      defaults.set(rows, forKey: "offlineOmissions")
      defaults.set(ownOmissions, forKey: "ownOfflineOmissions")
      defaults.set(offlineAvailable, forKey: "offlineAvailable")
      defaults.synchronize()
      
      // Disable save button
      
      saveButton.isEnabled = false
    } else {
      // Disable save button
      
      saveButton.isEnabled = false
      
      // Show alert
      
      let noConnectionAlert = UIAlertView(title: "Keine Internetverbindung", message: "Es besteht keine Verbindung zum Internet. Dadurch kann der Vertretungsplan nicht gesichert werden. Bitte überprüfe Deine Einstellungen.", delegate: self, cancelButtonTitle: "OK")
      noConnectionAlert.show()
    }
  }
}
