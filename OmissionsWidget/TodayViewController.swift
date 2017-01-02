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
  
  var defaults: NSUserDefaults!
  var selectedGrade = NSInteger()
  var rows = NSMutableArray()
  var ownOmissions = NSMutableArray()
  var teacherMode = Bool()
  var teacherToken = String()
  let grades = ["5a", "5b", "5c", "5d", "5e", "6a", "6b", "6c", "6d", "6e", "7a", "7b", "7c", "7d", "8a", "8b", "8c", "8d", "9a", "9b", "9c", "9d", "10a", "10b", "10c", "10d", "11a", "11b", "11c", "11d", "11e", "12a", "12b", "12c", "12d", "12e"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    // Initialize user defaults
    
    defaults = NSUserDefaults.standardUserDefaults()
    
    // Prepare omissions
    
    prepare()
    
    // Set preferred widget size
    
    if ownOmissions.count == 0 {
      preferredContentSize = CGSizeMake(preferredContentSize.width, 44)
    } else {
      preferredContentSize = CGSizeMake(preferredContentSize.width, CGFloat(ownOmissions.count) * 44)
    }
  }
  
  // Widget functions
  
  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    
    completionHandler(NCUpdateResult.NewData)
  }
  
  func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsetsZero
  }
  
  // Table view functions
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    var numberOfSections: Int
    
    let reachabilityStatus: NetworkStatus = Reachability.reachabilityForInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      numberOfSections = 1
    } else {
      numberOfSections = 0
      
      // Display label instead of table view
      
      let noConnectionLabel = UILabel.init()
      noConnectionLabel.text = "Keine Internetverbindung"
      noConnectionLabel.textColor = UIColor.lightTextColor()
      noConnectionLabel.font = UIFont.systemFontOfSize(16)
      noConnectionLabel.textAlignment = .Center
      
      tableView.separatorStyle = .None
      tableView.backgroundView = noConnectionLabel
    }
    
    return numberOfSections
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ownOmissions.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("OmissionsWidgetTableViewCell", forIndexPath: indexPath)
    
    // Prepare omissions
    
    var omissionComponents: [String]
    
    omissionComponents = ownOmissions[indexPath.row].componentsSeparatedByString("\",\"")
    
    // Create omission components
    
    let lesson = omissionComponents[1]
    let teacher = omissionComponents[2]
    let subject = omissionComponents[3]
    let room = omissionComponents[4]
    let text = omissionComponents[5]
    let comment = omissionComponents[6].stringByReplacingOccurrencesOfString("\"", withString: "")
    
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
    
    cell.textLabel!.text = cell.textLabel!.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    
    cell.detailTextLabel!.text = cell.detailTextLabel!.text?.stringByReplacingOccurrencesOfString("      ", withString: "   ")
    
    // Set cell's highlighted text color
    
    cell.textLabel?.highlightedTextColor = UIColor.blackColor()
    cell.detailTextLabel?.highlightedTextColor = UIColor.blackColor()
    
    // Disbale user interaction on iPad
    
    if UI_USER_INTERFACE_IDIOM() == .Pad {
      cell.userInteractionEnabled = false
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // Open omissions in app
    
    extensionContext?.openURL(NSURL.init(string: "elg://?page=omissions")!, completionHandler: nil)
  }
  
  override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footerLabel = UILabel()
    
    footerLabel.textColor = UIColor.lightGrayColor()
    footerLabel.font = UIFont.systemFontOfSize(16)
    footerLabel.textAlignment = .Center
    
    if ownOmissions.count == 0 {
      footerLabel.text = "Keine eigenen Vertretungen"
    } else {
      footerLabel.backgroundColor = UIColor.whiteColor()
    }
    
    return footerLabel
  }
  
  override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
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
    
    selectedGrade = defaults.integerForKey("selectedGrade")
    teacherMode = defaults.boolForKey("teacherMode")
    
    // Set teacher token when nil
    
    if defaults.stringForKey("teacherToken") == nil {
      defaults.setObject("", forKey: "teacherToken")
    }
    
    defaults.synchronize()
    
    teacherToken = defaults.stringForKey("teacherToken")!
    
    // Download omissions
    
    downloadOmissions()
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
      
      // Reset own omissions
      
      ownOmissions = NSMutableArray()
      
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
          if teacher == teacherToken && teacher != "" {
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
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
