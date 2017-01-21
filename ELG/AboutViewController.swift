//
//  AboutViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 27/11/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit
import MessageUI

class AboutViewController: UITableViewController, MFMailComposeViewControllerDelegate {
  // Variables + constants
  
  var defaults: NSUserDefaults!
  let aboutWebViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("AboutWebViewController")
  let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
		
		defaults = NSUserDefaults.standardUserDefaults()
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
          cell.detailTextLabel!.text = version
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
        cell.textLabel!.text = "Impressum der Website"
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
        // Open URL
        
        UIApplication.sharedApplication().openURL(NSURL.init(string: "http://www.johjakob.de")!)
      } else if indexPath.row == 2 {
        // Set user default
        
        defaults.setInteger(0, forKey: "selectedAboutWebView")
        defaults.synchronize()
        
        // Show new view
        
        if #available(iOS 8, *) {
          navigationController?.showViewController(aboutWebViewController, sender: self)
        } else {
          navigationController?.pushViewController(aboutWebViewController, animated: true)
        }
      }
      
      break
    case 1:
      if indexPath.row == 0 {
        // Check whether device can send mail
        
        if MFMailComposeViewController.canSendMail() {
          // Compose mail
          
          let mailController = MFMailComposeViewController.init()
          
          mailController.setToRecipients(["johannes.jakob@elg-halle.de"])
          mailController.setSubject("ELG v" + version! + " (iOS)")
          mailController.setMessageBody("", isHTML: true)
          
          mailController.mailComposeDelegate = self
          
          // Present mail compose view
          
          presentViewController(mailController, animated: true, completion: nil)
        } else {
          // Show alert
          
          let mailErrorAlert = UIAlertView(title: "Senden nicht möglich", message: "Dein Gerät kann keine E-Mails senden. Bitte überprüfe Deine Einstellungen.", delegate: self, cancelButtonTitle: "OK")
          mailErrorAlert.show()
        }
      } else {
        // Open URL
        
        UIApplication.sharedApplication().openURL(NSURL.init(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=968363965&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software")!)
      }
      
      break
    case 2:
      // Set user default
      
      defaults.setInteger(1, forKey: "selectedAboutWebView")
      defaults.synchronize()
      
      // Show new view
			
			navigationController?.showViewController(aboutWebViewController, sender: self)
      
      break
    case 3:
      // Set user default
      
      defaults.setInteger(2, forKey: "selectedAboutWebView")
      defaults.synchronize()
      
      // Show new view
			
			navigationController?.showViewController(aboutWebViewController, sender: self)
      
      break
    default:
      break
    }
  }
  
  override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    // Check table view section and set title for table view section footer
    
    if section == 3 {
      return "© 2012-2017 Elisabeth-Gymnasium Halle, Johannes Jakob"
    } else {
      return nil
    }
  }
  
  // Mail compose functions
  
  func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
