//
//  TodayViewController.swift
//  OmissionsWidget
//
//  Created by Johannes Jakob on 21/12/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit
import NotificationCenter

class TodayViewController: UITableViewController, NCWidgetProviding {
  // Variables + constants
  
  var defaults: UserDefaults!
  var selectedGrade = NSInteger()
  var rows = NSMutableArray()
  var ownOmissions = NSMutableArray()
  var teacherMode = Bool()
  var teacherToken = String()
  let grades = ["5a", "5b", "5c", "5d", "5e", "6a", "6b", "6c", "6d", "6e", "7a", "7b", "7c", "7d", "8a", "8b", "8c", "8d", "9a", "9b", "9c", "9d", "10a", "10b", "10c", "10d", "11a", "11b", "11c", "11d", "11e", "12a", "12b", "12c", "12d", "12e"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // Initialize user defaults
    
    defaults = UserDefaults.standard
    
    // Prepare omissions
    
    prepare()
    
    // Set preferred widget size
    
    if ownOmissions.count == 0 {
      preferredContentSize = CGSize(width: preferredContentSize.width, height: 44)
    } else {
      preferredContentSize = CGSize(width: preferredContentSize.width, height: CGFloat(ownOmissions.count) * 44)
    }
  }
  
  // Widget functions
  
  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    
    completionHandler(NCUpdateResult.newData)
  }
  
  func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets.zero
  }
  
  // Table view functions
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    var numberOfSections: Int
    
    let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      numberOfSections = 1
    } else {
      numberOfSections = 0
      
      // Display label instead of table view
      
      let noConnectionLabel = UILabel.init()
      noConnectionLabel.text = "Keine Internetverbindung"
      noConnectionLabel.textColor = UIColor.lightText
      noConnectionLabel.font = UIFont.systemFont(ofSize: 16)
      noConnectionLabel.textAlignment = .center
      
      tableView.separatorStyle = .none
      tableView.backgroundView = noConnectionLabel
    }
    
    return numberOfSections
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ownOmissions.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OmissionsWidgetTableViewCell", for: indexPath)
    
    // Prepare omissions
    
    var omissionComponents: [String]
    
    omissionComponents = (ownOmissions[indexPath.row] as AnyObject).components(separatedBy: "\",\"")
    
    // Create omission components
    
    let lesson = omissionComponents[1]
    let teacher = omissionComponents[2]
    let subject = omissionComponents[3]
    let room = omissionComponents[4]
    let text = omissionComponents[5]
    let comment = omissionComponents[6].replacingOccurrences(of: "\"", with: "")
    
    // Set cell's text
    
    if subject == "" && teacher == "" {
      cell.textLabel!.text = lesson + ". Stunde"
    } else if subject == "" {
      cell.textLabel!.text = lesson + ". Stunde" + " (" + teacher + ")"
    } else if teacher == "" {
      cell.textLabel!.text = lesson + ". Stunde" + ": " + subject
    } else {
      cell.textLabel!.text = lesson + ". Stunde" + ": " + subject + " (" + teacher + ")"
    }
    
    if room == "" {
      cell.detailTextLabel!.text = text + "   " + comment
    } else {
      cell.detailTextLabel!.text = "Raum " + room + "   " + text + "   " + comment
    }
    
    // Remove unnecessary whitespaces
    
    cell.textLabel!.text = cell.textLabel!.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    
    cell.detailTextLabel!.text = cell.detailTextLabel!.text?.replacingOccurrences(of: "      ", with: "   ")
    
    // Set cell's highlighted text color
    
    cell.textLabel?.highlightedTextColor = UIColor.black
    cell.detailTextLabel?.highlightedTextColor = UIColor.black
    
    // Disbale user interaction on iPad
    
    if UI_USER_INTERFACE_IDIOM() == .pad {
      cell.isUserInteractionEnabled = false
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Open omissions in app
    
    extensionContext?.open(URL.init(string: "elg://?page=omissions")!, completionHandler: nil)
  }
  
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footerLabel = UILabel()
    
    footerLabel.textColor = UIColor.lightGray
    footerLabel.font = UIFont.systemFont(ofSize: 16)
    footerLabel.textAlignment = .center
    
    if ownOmissions.count == 0 {
      footerLabel.text = "Keine eigenen Vertretungen"
    } else {
      footerLabel.backgroundColor = UIColor.white
    }
    
    return footerLabel
  }
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    var heightForFooter: CGFloat = 0
    
    if ownOmissions.count == 0 {
      heightForFooter = 44
    } else {
      heightForFooter = 0
    }
    
    return heightForFooter
  }
  
  // Custom functions
  
  func prepare() {
    // Retrieve variables from user defaults
    
    selectedGrade = defaults.integer(forKey: "selectedGrade")
    teacherMode = defaults.bool(forKey: "teacherMode")
    
    // Set teacher token when nil
    
    if defaults.string(forKey: "teacherToken") == nil {
      defaults.set("", forKey: "teacherToken")
    }
    
    defaults.synchronize()
    
    teacherToken = defaults.string(forKey: "teacherToken")!
    
    // Download omissions
    
    downloadOmissions()
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
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
