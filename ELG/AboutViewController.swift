//
//  AboutViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 27/11/2016
//  © Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit
import MessageUI
import StoreKit
import SafariServices

class AboutViewController: UITableViewController, MFMailComposeViewControllerDelegate, SFSafariViewControllerDelegate {
  // MARK: - Properties
  
  var defaults: UserDefaults!
  let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	
	// MARK: - UITableViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
		
		defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
		
		if #available(iOS 10.3, *) {
			SKStoreReviewController.requestReview()
		}
  }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
  // MARK: - UITableView
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRows = Int()
		
		let date = Date()
		let pollEndDateString = "2020-07-01"
		let dateFormatter = DateFormatter()
		
		dateFormatter.dateFormat = "yyyy-MM-dd"
		
		let pollEndDate = dateFormatter.date(from: pollEndDateString)
		let order = Calendar.current.compare(date, to: pollEndDate!, toGranularity: .day)
    
    switch section {
    case 0:
			if order == .orderedAscending {
				numberOfRows = 4
			} else {
				numberOfRows = 3
			}
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
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Check index path and set table view cell's properties
    
    if indexPath.section == 0 {
			if indexPath.row < 2 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutDetailTableViewCell", for: indexPath)
        
        if indexPath.row == 0 {
          cell.textLabel!.text = "Version"
          cell.detailTextLabel!.text = version
        } else {
          cell.textLabel!.text = "Entwickler"
          cell.detailTextLabel!.text = "Johannes Jakob"
          cell.selectionStyle = .default
        }
        
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutTableViewCell", for: indexPath)
        
				if indexPath.row == 2 {
					cell.textLabel!.text = "Was ist neu?"
				} else {
					cell.textLabel!.text = "Feature-Umfrage beantworten"
				}
				
        cell.accessoryType = .disclosureIndicator
        
        return cell
      }
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "AboutTableViewCell", for: indexPath)
      
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
        cell.accessoryType = .disclosureIndicator
        break
      case 3:
        cell.textLabel!.text = "Impressum"
        cell.accessoryType = .disclosureIndicator
        break
      default:
        break
      }
      
      return cell
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Deselect table view cell
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    // Check selected table view cell and act based on selection
    
    switch indexPath.section {
    case 0:
      if indexPath.row == 1 {
        // Open URL
        
        UIApplication.shared.openURL(URL.init(string: "https://johjakob.com")!)
      } else if indexPath.row == 2 {
        // Set user default
        
        defaults.set(0, forKey: "selectedAboutWebView")
        defaults.synchronize()
        
        // Show new view
				
				var aboutWebViewController = UIViewController()
				
				if #available(iOS 11, *) {
					aboutWebViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AboutWebViewController")
				} else {
					aboutWebViewController = UIStoryboard(name: "MainLegacy", bundle: Bundle.main).instantiateViewController(withIdentifier: "AboutWebViewController")
				}
        
        if #available(iOS 8, *) {
          navigationController?.show(aboutWebViewController, sender: self)
        } else {
          navigationController?.pushViewController(aboutWebViewController, animated: true)
        }
			} else if indexPath.row == 3 {
				let pollURLString = "https://johannesjakob.typeform.com/to/CNzyBw"
				
				if #available(iOS 9, *) {
					let pollSafariView = SFSafariViewController(url: URL(string: pollURLString)!)
					
					pollSafariView.delegate = self
					
					self.present(pollSafariView, animated: true, completion: nil)
				} else {
					UIApplication.shared.openURL(URL.init(string: pollURLString)!)
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
          
          present(mailController, animated: true, completion: nil)
        } else {
          // Show alert
          
          let mailErrorAlert = UIAlertView(title: "Senden nicht möglich", message: "Dein Gerät kann keine E-Mails senden. Bitte überprüfe Deine Einstellungen.", delegate: self, cancelButtonTitle: "OK")
          mailErrorAlert.show()
        }
      } else {
        // Open URL
        
        UIApplication.shared.openURL(URL.init(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=968363965&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software")!)
      }
      
      break
    case 2:
      // Set user default
      
      defaults.set(1, forKey: "selectedAboutWebView")
      defaults.synchronize()
      
      // Show new view
			
			var aboutWebViewController = UIViewController()
			
			if #available(iOS 11, *) {
				aboutWebViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AboutWebViewController")
			} else {
				aboutWebViewController = UIStoryboard(name: "MainLegacy", bundle: Bundle.main).instantiateViewController(withIdentifier: "AboutWebViewController")
			}
			
			navigationController?.show(aboutWebViewController, sender: self)
      
      break
    case 3:
      // Set user default
      
      defaults.set(2, forKey: "selectedAboutWebView")
      defaults.synchronize()
      
      // Show new view
			
			var aboutWebViewController = UIViewController()
			
			if #available(iOS 11, *) {
				aboutWebViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AboutWebViewController")
			} else {
				aboutWebViewController = UIStoryboard(name: "MainLegacy", bundle: Bundle.main).instantiateViewController(withIdentifier: "AboutWebViewController")
			}
			
			navigationController?.show(aboutWebViewController, sender: self)
      
      break
    default:
      break
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    // Check table view section and set title for table view section footer
    
    if section == 3 {
      return "© Elisabeth-Gymnasium Halle, Johannes Jakob"
    } else {
      return nil
    }
  }
  
  // MARK: - MFMailComposeViewController
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    dismiss(animated: true, completion: nil)
  }
}
