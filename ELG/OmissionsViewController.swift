//
//  OmissionsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 21/07/2016
//  © 2016 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class OmissionsViewController: UITableViewController {
  // Outlets
  
  @IBOutlet weak private var saveButton: UIBarButtonItem!
  
  // Variables + constants
  
  var defaults: NSUserDefaults!
  var selectedGrade = NSInteger()
  var rows = NSMutableArray()
  var ownOmissions = NSMutableArray()
  var offlineAvailable = Bool()
  var autoSave = Bool()
  var teacherMode = Bool()
  var teacherToken = String()
  let grades = ["5a", "5b", "5c", "5d", "5e", "6a", "6b", "6c", "6d", "6e", "7a", "7b", "7c", "7d", "8a", "8b", "8c", "8d", "9a", "9b", "9c", "9d", "10a", "10b", "10c", "10d", "11a", "11b", "11c", "11d", "11e", "12a", "12b", "12c", "12d", "12e"]
  
  // Actions
  
  @IBAction func saveButtonTap(sender: UIBarButtonItem) {
    saveOmissions()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
    
    if #available(iOS 8, *) {
      defaults = NSUserDefaults.standardUserDefaults()
    } else {
      defaults = NSUserDefaults.init(suiteName: "group.com.hardykrause.elg")
    }
    
    // Register custom table view cell
    
    tableView.registerNib(UINib(nibName: "OmissionsTableViewCell", bundle: nil), forCellReuseIdentifier: "OmissionsTableViewCell")
    
    // Set up refresh control
    
    let omissionsRefreshControl = UIRefreshControl.init()
    
    omissionsRefreshControl.addTarget(self, action: #selector(OmissionsViewController.refreshTableView), forControlEvents: .ValueChanged)
    
    refreshControl = omissionsRefreshControl
    
    // Prepare omissions
    
    prepare()
  }
  
  // Table view functions
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    var numberOfSections: Int
    
    let reachabilityStatus: NetworkStatus = Reachability.reachabilityForInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      numberOfSections = 2
    } else {
      numberOfSections = 0
      
      // Display label instead of table view
      
      let noConnectionLabel = UILabel.init()
      noConnectionLabel.text = "Keine Internetverbindung"
      noConnectionLabel.textColor = UIColor.lightGrayColor()
      noConnectionLabel.font = UIFont.systemFontOfSize(16)
      noConnectionLabel.textAlignment = .Center
      
      tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
      tableView.separatorStyle = .None
      tableView.backgroundView = noConnectionLabel
    }
    
    return numberOfSections
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRows: Int
    
    if section == 0 {
      numberOfRows = ownOmissions.count
    } else {
      let reachabilityStatus: NetworkStatus = Reachability.reachabilityForInternetConnection().currentReachabilityStatus()
      
      if reachabilityStatus != NotReachable {
        numberOfRows = rows.count - 2
      } else if rows.count < 3 && reachabilityStatus != NotReachable {
        numberOfRows = 0
      } else {
        numberOfRows = 0
      }
    }
    
    return numberOfRows
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("OmissionsTableViewCell", forIndexPath: indexPath) as! OmissionsTableViewCell
    
    // Prepare omissions
    
    var omissionComponents: [String]
    
    if indexPath.section == 0 {
      omissionComponents = ownOmissions[indexPath.row].componentsSeparatedByString("\",\"")
    } else {
      omissionComponents = rows[indexPath.row + 1].componentsSeparatedByString("\",\"")
    }
    
    // Create omission components
    
    let grade = omissionComponents[0].stringByReplacingOccurrencesOfString("\"", withString: "")
    let lesson = omissionComponents[1]
    let teacher = omissionComponents[2]
    let subject = omissionComponents[3]
    let room = omissionComponents[4]
    let text = omissionComponents[5]
    let comment = omissionComponents[6].stringByReplacingOccurrencesOfString("\"", withString: "")
    
    // Set cell's text
    
    if grade.characters.count < 4 {
      cell.gradeLabel.text = grade
    } else {
      if grade.characters.first == "1" {
        cell.gradeLabel.text = grade.substringToIndex(grade.startIndex.advancedBy(2))
      } else {
        cell.gradeLabel.text = grade.substringToIndex(grade.startIndex.advancedBy(1))
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
    
    cell.detailsLabel.text = cell.detailsLabel.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    
    cell.detailsLabel.text = cell.detailsLabel.text?.stringByReplacingOccurrencesOfString("      ", withString: "   ")
    
    // Change color of lesson label
    
    if comment == "Entfall" {
      cell.lessonLabel.textColor = UIColor(red: 0.498, green: 0.09, blue: 0.203, alpha: 1)
    } else {
      cell.lessonLabel.textColor = UIColor.blackColor()
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 65
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var titleForHeader: String
    
    if section == 0 {
      titleForHeader = "Eigene Vertretungen"
    } else {
      titleForHeader = "Alle Vertretungen"
    }
    
    return titleForHeader
  }
  
  override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footerLabel = UILabel()
    
    footerLabel.textColor = UIColor.lightGrayColor()
    footerLabel.font = UIFont.systemFontOfSize(16)
    footerLabel.textAlignment = .Center
    
    if section == 0 {
      if ownOmissions.count == 0 {
        footerLabel.text = "Keine eigenen Vertretungen"
      } else {
        footerLabel.backgroundColor = UIColor.whiteColor()
      }
    } else {
      if rows.count < 3 {
        footerLabel.text = "Keine Vertretungen"
      } else {
        footerLabel.backgroundColor = UIColor.whiteColor()
      }
    }
    
    return footerLabel
  }
  
  override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
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
  
  // Custom functions
  
  func prepare() {
    // Retrieve variables from user defaults
    
    selectedGrade = defaults.integerForKey("selectedGrade")
    offlineAvailable = defaults.boolForKey("offlineAvailable")
    autoSave = defaults.boolForKey("autoSave")
    teacherMode = defaults.boolForKey("teacherMode")
    teacherToken = defaults.stringForKey("teacherToken")!
    
    // Retrieve offline omissions if available
    
    if offlineAvailable {
      getOfflineOmissions()
    } else {
      downloadOmissions()
    }
  }
  
  func refreshTableView() {
    downloadOmissions()
    
    tableView.reloadData()
    
    refreshControl?.endRefreshing()
  }
  
  func getOfflineOmissions() {
    // Retrieve offline omissions
    
    rows = defaults.mutableArrayValueForKey("offlineOmissions")
    ownOmissions = defaults.mutableArrayValueForKey("ownOfflineOmissions")
    
    // Set date
    
    navigationItem.title = rows[0] as? String
    
    // Disable save button
    
    saveButton.enabled = false
  }
  
  func downloadOmissions() {
    // Check internet reachability
    
    let reachabilityStatus: NetworkStatus = Reachability.reachabilityForInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      // Download CSV file
      
      var rawOmissions = String()
      
      do {
        try rawOmissions = String(contentsOfURL: NSURL.init(string: "http://elg-halle.de/Aktuell/Intern/Vertretungsplan/vp.csv")!, encoding: NSASCIIStringEncoding)
      } catch {
        print(error)
      }
      
      // Convert raw data into array
      
      let cleanedOmissions = rawOmissions.stringByReplacingOccurrencesOfString("\r", withString: "")
      
      rows = NSMutableArray.init(array: cleanedOmissions.componentsSeparatedByString("\n"))
      
      // Process array
      
      for i in 1 ..< rows.count - 1 {
        // Remove lunch break
        
        if rows[i].rangeOfString("MIPa").location != NSNotFound {
          rows.removeObjectAtIndex(i)
        }
        
        // Prepare getting own omissions
        
        let omissionComponents = rows[i].componentsSeparatedByString("\",\"")
        let grade = omissionComponents[0].stringByReplacingOccurrencesOfString("\"", withString: "")
        var teacher = String()
        
        // Get teacher of omission
        
        if omissionComponents.count >= 3 {
          teacher = omissionComponents[2]
        }
        
        // Check teacher mode or selected grade to get own omissions
        
        if teacherMode {
          if teacher == teacherToken {
            ownOmissions.addObject(rows[i])
          }
        } else {
          if selectedGrade != 0 {
            if grade.rangeOfString(grades[selectedGrade - 1]) != nil {
              ownOmissions.addObject(rows[i])
            }
          }
        }
      }
      
      // Set date
      
      navigationItem.title = rows[0] as? String
      
      // Save omissions if setting is activated
      
      // Reset table view appearance
      
      tableView.backgroundColor = UIColor.whiteColor()
      tableView.separatorStyle = .SingleLine
      
      // Set offline availability status
      
      offlineAvailable = false
      
      // Set user default
      
      defaults.setBool(offlineAvailable, forKey: "offlineAvailable")
      defaults.synchronize()
      
      // Enable save button
      
      saveButton.enabled = true
      
      if autoSave {
        saveOmissions()
      }
    } else {
      // Disable save button
      
      saveButton.enabled = false
      
      // Show alert
      
      let noConnectionAlert = UIAlertView(title: "Keine Internetverbindung", message: "Es besteht keine Verbindung zum Internet. Bitte überprüfe Deine Einstellungen.", delegate: self, cancelButtonTitle: "OK")
      noConnectionAlert.show()
      
      // Change table view appearance
      
      tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
      tableView.separatorStyle = .None
    }
  }
  
  func saveOmissions() {
    // Check internet reachability
    
    let reachabilityStatus: NetworkStatus = Reachability.reachabilityForInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      // Save omissions
      
      offlineAvailable = true
      
      defaults.setObject(rows, forKey: "offlineOmissions")
      defaults.setObject(ownOmissions, forKey: "ownOfflineOmissions")
      defaults.setBool(offlineAvailable, forKey: "offlineAvailable")
      defaults.synchronize()
      
      // Disable save button
      
      saveButton.enabled = false
    } else {
      // Disable save button
      
      saveButton.enabled = false
      
      // Show alert
      
      let noConnectionAlert = UIAlertView(title: "Keine Internetverbindung", message: "Es besteht keine Verbindung zum Internet. Dadurch kann der Vertretungsplan nicht gesichert werden. Bitte überprüfe Deine Einstellungen.", delegate: self, cancelButtonTitle: "OK")
      noConnectionAlert.show()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
