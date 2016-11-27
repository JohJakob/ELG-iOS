//
//  AboutViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 27/11/2016
//  © 2016 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class AboutViewController: UITableViewController {
  // Variables + constants
  
  var defaults: NSUserDefaults!
  let aboutWebViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("AboutWebViewController")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
    
    if #available(iOS 8, *) {
      defaults = NSUserDefaults.standardUserDefaults()
    } else {
      defaults = NSUserDefaults.init(suiteName: "group.com.hardykrause.elg")
    }
  }
  
  // Table view functions
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 4
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRows = Int()
    
    switch section {
    case 0:
      numberOfRows = 3
      break
    case 1:
      numberOfRows = 2
      break
    default:
      numberOfRows = 1
      break
    }
    
    return numberOfRows
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    // Check index path and set table view cell's properties
    
    if indexPath.section == 0 {
      if indexPath.row != 2 {
        let cell = tableView.dequeueReusableCellWithIdentifier("AboutDetailTableViewCell", forIndexPath: indexPath)
        
        if indexPath.row == 0 {
          cell.textLabel!.text = "Version"
          cell.detailTextLabel!.text = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
        } else {
          cell.textLabel!.text = "Entwickler"
          cell.detailTextLabel!.text = "Johannes Jakob"
          cell.selectionStyle = .Default
        }
        
        return cell
      } else {
        let cell = tableView.dequeueReusableCellWithIdentifier("AboutTableViewCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = "Was ist neu?"
        cell.accessoryType = .DisclosureIndicator
        
        return cell
      }
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("AboutTableViewCell", forIndexPath: indexPath)
      
      switch indexPath.section {
      case 1:
        if indexPath.row == 0 {
          cell.textLabel!.text = "E-Mail senden"
        } else {
          cell.textLabel!.text = "Bewerten"
        }
        
        break
      case 2:
        cell.textLabel!.text = "Open Source"
        cell.accessoryType = .DisclosureIndicator
        break
      case 3:
        cell.textLabel!.text = "Impressum"
        cell.accessoryType = .DisclosureIndicator
        break
      default:
        break
      }
      
      return cell
    }
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // Deselect table view cell
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    // Check selected table view cell and act based on selection
    
    switch indexPath.section {
    case 0:
      if indexPath.row == 1 {
        UIApplication.sharedApplication().openURL(NSURL.init(string: "http://www.johjakob.de")!)
      } else if indexPath.row == 2 {
        defaults.setInteger(0, forKey: "selectedAboutWebView")
        defaults.synchronize()
        
        if #available(iOS 8, *) {
          navigationController?.showViewController(aboutWebViewController, sender: self)
        } else {
          navigationController?.pushViewController(aboutWebViewController, animated: true)
        }
      }
      
      break
    case 1:
      if indexPath.row == 0 {
        
      } else {
        UIApplication.sharedApplication().openURL(NSURL.init(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=968363965&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software")!)
      }
      
      break
    case 2:
      defaults.setInteger(1, forKey: "selectedAboutWebView")
      defaults.synchronize()
      
      if #available(iOS 8, *) {
        navigationController?.showViewController(aboutWebViewController, sender: self)
      } else {
        navigationController?.pushViewController(aboutWebViewController, animated: true)
      }
      
      break
    case 3:
      defaults.setInteger(2, forKey: "selectedAboutWebView")
      defaults.synchronize()
      
      if #available(iOS 8, *) {
        navigationController?.showViewController(aboutWebViewController, sender: self)
      } else {
        navigationController?.pushViewController(aboutWebViewController, animated: true)
      }
      
      break
    default:
      break
    }
  }
  
  override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    // Check table view section and set title for table view section footer
    
    if section == 3 {
      return "© 2012-2016 Elisabeth-Gymnasium Halle, Johannes Jakob"
    } else {
      return nil
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
