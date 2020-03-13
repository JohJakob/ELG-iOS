//
//  TodayViewController.swift
//  OmissionsWidget
//
//  Created by Johannes Jakob on 21/12/2016
//  © 2016-2018 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit
import NotificationCenter

class TodayViewController: UITableViewController, NCWidgetProviding {
  // MARK: - Properties
  
  var defaults: UserDefaults!
  var selectedGrade = Int()
  var rows = NSMutableArray()
  var ownOmissions = NSMutableArray()
  var teacherMode = Bool()
  var teacherToken = String()
  let grades = ["Keine Klasse", "5a", "5b", "5c", "5d", "5e", "6a", "6b", "6c", "6d", "6e", "7a", "7b", "7c", "7d", "7e", "8a", "8b", "8c", "8d", "8e", "9a", "9b", "9c", "9d", "9e", "10a", "10b", "10c", "10d", "10e", "11a", "11b", "11c", "11d", "11e", "12a", "12b", "12c", "12d", "12e"]
	
	// MARK: - UITableViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
    
    prepare()
    
    if ownOmissions.count == 0 {
      preferredContentSize = CGSize(width: preferredContentSize.width, height: 44)
    } else {
      preferredContentSize = CGSize(width: preferredContentSize.width, height: CGFloat(ownOmissions.count) * 44)
			
			if #available(iOSApplicationExtension 10.0, *) {
				extensionContext?.widgetLargestAvailableDisplayMode = .expanded
			}
    }
  }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
  // MARK: - NCWidgetProviding
  
  func widgetPerformUpdate(_ completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
		
    completionHandler(NCUpdateResult.newData)
  }
  
  func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets.zero
  }
	
	@available(iOSApplicationExtension 10.0, *)
	
	func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
		preferredContentSize = (activeDisplayMode == .expanded) ? CGSize(width: preferredContentSize.width, height: CGFloat(ownOmissions.count) * 44) : CGSize(width: preferredContentSize.width, height: 110)
	}
  
  // MARK: - UITableView
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    var numberOfSections: Int
    
    let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      numberOfSections = 1
    } else {
      numberOfSections = 0
      
      let noConnectionLabel = UILabel.init()
      noConnectionLabel.text = "Keine Verbindung"
      noConnectionLabel.textColor = UIColor.lightText
			noConnectionLabel.font = UIFont.systemFont(ofSize: 16)
      noConnectionLabel.textAlignment = .center
			
			if #available(iOSApplicationExtension 10, *) {
				noConnectionLabel.textColor = UIColor.gray
			}
      
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
    
    var omissionComponents: [String]
    
    omissionComponents = (ownOmissions[indexPath.row] as AnyObject).components(separatedBy: "\",\"")
    
    let lesson = omissionComponents[1]
    let teacher = omissionComponents[2]
    let subject = omissionComponents[3]
    let room = omissionComponents[4]
    let text = omissionComponents[5]
    let comment = omissionComponents[6].replacingOccurrences(of: "\"", with: "")
    
    if subject == "" && teacher == "" {
      cell.textLabel!.text = lesson + ". Stunde"
    } else if subject == "" {
      cell.textLabel!.text = lesson + ". Stunde" + " (" + teacher + ")"
    } else if teacher == "" {
      cell.textLabel!.text = lesson + ". Stunde" + ": " + subject
    } else {
      cell.textLabel!.text = lesson + ". Stunde" + ": " + subject + " (" + teacher + ")"
    }
    
    if room == "" && text == "" {
      cell.detailTextLabel!.text = comment
    } else if room == "" {
			cell.detailTextLabel!.text = text + "   " + comment
		} else if text == "" {
			cell.detailTextLabel!.text = "Raum " + room + "   " + comment
		} else {
			cell.detailTextLabel!.text = "Raum " + room + "   " + text + "   " + comment
		}
    
    cell.textLabel!.text = cell.textLabel!.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    
    cell.detailTextLabel!.text = cell.detailTextLabel!.text?.replacingOccurrences(of: "      ", with: "   ")
		
		if #available(iOSApplicationExtension 10.0, *) {
			cell.textLabel?.textColor = UIColor.black
			cell.detailTextLabel?.textColor = UIColor.gray
		} else {
			cell.textLabel?.highlightedTextColor = UIColor.black
			cell.detailTextLabel?.highlightedTextColor = UIColor.black
		}
		
		if #available(iOSApplicationExtension 8.2, *) {
			cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
		} else {
			cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
		}
    
    return cell
  }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		extensionContext?.open(URL.init(string: "elg://?page=omissions")!, completionHandler: nil)
	}
	
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footerLabel = UILabel()
    
    footerLabel.textColor = UIColor.lightGray
    footerLabel.font = UIFont.systemFont(ofSize: 16)
    footerLabel.textAlignment = .center
		
		if #available(iOSApplicationExtension 10, *) {
			footerLabel.textColor = UIColor.gray
		}
    
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
			
			if #available(iOSApplicationExtension 10, *) {
				heightForFooter = 110
			}
    } else {
      heightForFooter = 0
    }
    
    return heightForFooter
  }
	
  // MARK: - Custom
  
  func prepare() {
    selectedGrade = defaults.integer(forKey: "grade")
    teacherMode = defaults.bool(forKey: "teacherMode")
		
    if defaults.string(forKey: "teacherToken") == nil {
      defaults.set("", forKey: "teacherToken")
    }
    
    defaults.synchronize()
    
    teacherToken = defaults.string(forKey: "teacherToken")!
    
    downloadOmissions()
		
		tableView.reloadData()
  }
  
  func downloadOmissions() {
    let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      var rawOmissions = String()
      
      do {
        try rawOmissions = String(contentsOf: URL.init(string: "https://elg-halle.de/Aktuell/Intern/Vertretungsplan/vp.csv")!, encoding: String.Encoding.ascii)
      } catch {
        print(error)
      }
      
      let cleanedOmissions = rawOmissions.replacingOccurrences(of: "\r", with: "")
      
      rows = NSMutableArray.init(array: cleanedOmissions.components(separatedBy: "\n"))
      
      ownOmissions = NSMutableArray()
      
      for i in 1 ..< rows.count - 1 {
        if (rows[i] as AnyObject).range(of: "MIPa").location != NSNotFound {
          rows.removeObject(at: i)
        }
        
        let omissionComponents = (rows[i] as AnyObject).components(separatedBy: "\",\"")
        let grade = omissionComponents[0].replacingOccurrences(of: "\"", with: "")
        var teacher = String()
        
        if omissionComponents.count >= 3 {
          teacher = omissionComponents[2]
        }
        
        if teacherMode {
          if teacher == teacherToken && teacher != "" {
            ownOmissions.add(rows[i])
          }
        } else {
          if selectedGrade != 0 {
            if grade.range(of: grades[selectedGrade]) != nil {
              ownOmissions.add(rows[i])
            }
          }
        }
      }
    }
  }
}
