//
//  WebScheduleViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 27/06/2016
//  © Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class WebScheduleViewController: UIViewController, UIWebViewDelegate {
  // MARK: - Properties
  
  @IBOutlet weak fileprivate var scheduleWebView: UIWebView!
  @IBOutlet weak fileprivate var activityIndicator: UIActivityIndicatorView!
  
  var defaults: UserDefaults!
  let grades = ["5a", "5b", "5c", "5d", "5e", "6a", "6b", "6c", "6d", "6e", "7a", "7b", "7c", "7d", "7e", "8a", "8b", "8c", "8d", "9a", "9b", "9c", "9d", "10a", "10b", "10c", "10d"]
  var url: String!
	
	// MARK: - UIViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
		
		defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
    
    loadSchedule()
  }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
  // MARK: - UIWebView
  
  func webViewDidStartLoad(_ webView: UIWebView) {
    // Start Activity Indicator
    
    activityIndicator.startAnimating()
  }
  
  func webViewDidFinishLoad(_ webView: UIWebView) {
    // Stop Activity Indicator
    
    activityIndicator.stopAnimating()
    
    // Get user defaults
    
    let username = defaults.string(forKey: "username")
    let password = defaults.string(forKey: "password")
    
    // Check Internet reachability
    
    let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      // Get grade user default
      
      let grade = defaults.integer(forKey: "grade")
      
      // Log in and load individual schedule website
      
      if grade > 25 {
        if username != "" || password != "" {
          // Create JavaScript
          
          let fillUsernameScript = "var inputFields = document.getElementsByTagName('input'); for (var i = inputFields.length >>> 0; i--;) { if (inputFields[i].name == 'txtBenutzername') { inputFields[i].value = '" + username! + "'; } }"
          let fillPasswordScript = "for (var i = inputFields.length >>> 0; i--;) { if (inputFields[i].name == 'txtKennwort') { inputFields[i].value = '" + password! + "'; } }"
          let loginScript = "document.getElementById('btnAnmelden').click();"
          
          // Execute JavaScript in Web View
          
          scheduleWebView.stringByEvaluatingJavaScript(from: fillUsernameScript)
          scheduleWebView.stringByEvaluatingJavaScript(from: fillPasswordScript)
          scheduleWebView.stringByEvaluatingJavaScript(from: loginScript)
        }
      }
    }
  }
  
  func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    // Stop Activity Indicator
    
    activityIndicator.stopAnimating()
    
    // Show alert
    
    let webViewErrorAlert = UIAlertView(title: "Fehler", message: "Beim Laden ist ein Fehler aufgetreten.", delegate: self, cancelButtonTitle: "OK")
    webViewErrorAlert.show()
  }
  
  // MARK: - Custom
  
  func loadSchedule() {
    // Set Web View delegate
    
    scheduleWebView.delegate = self
    
    // Check Internet reachability
    
    let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      // Get user defaults
      
      let grade = defaults.integer(forKey: "grade")
      let token = defaults.string(forKey: "token")
      
      // Set schedule URL
      
      switch grade {
      case 0:
        url = "http://elg-halle.de/Aktuell/Intern/Stundenplaene/Klassen/Kla1A.htm"
        break
      case 26:
        url = "http://www.elg-halle.de/Aktuell/Intern/default.aspx?ReturnUrl=/Aktuell/Intern/Stundenplaene/schueler/stu1.aspx"
        break
      case 27:
        url = "http://www.elg-halle.de/Aktuell/Intern/default.aspx?ReturnUrl=/Aktuell/Intern/Stundenplaene/schueler/stu1.aspx"
        break
      case 28:
        url = "http://www.elg-halle.de/Aktuell/Intern/default.aspx?ReturnUrl=/Aktuell/Intern/Stundenplaene/schueler/stu1.aspx"
        break
      case 29:
        url = "http://www.elg-halle.de/Aktuell/Intern/default.aspx?ReturnUrl=/Aktuell/Intern/Stundenplaene/schueler/stu1.aspx"
        break
      case 30:
        url = "http://www.elg-halle.de/Aktuell/Intern/default.aspx?ReturnUrl=/Aktuell/Intern/Stundenplaene/schueler/stu1.aspx"
        break
      case 31:
        url = "http://www.elg-halle.de/Aktuell/Intern/default.aspx?ReturnUrl=/Aktuell/Intern/Stundenplaene/schueler/stu1.aspx"
        break
      case 32:
        url = "http://www.elg-halle.de/Aktuell/Intern/default.aspx?ReturnUrl=/Aktuell/Intern/Stundenplaene/schueler/stu1.aspx"
        break
      case 33:
        url = "http://www.elg-halle.de/Aktuell/Intern/default.aspx?ReturnUrl=/Aktuell/Intern/Stundenplaene/schueler/stu1.aspx"
        break
      case 34:
        url = "http://www.elg-halle.de/Aktuell/Intern/default.aspx?ReturnUrl=/Aktuell/Intern/Stundenplaene/schueler/stu1.aspx"
        break
      case 35:
        url = "http://www.elg-halle.de/Aktuell/Intern/default.aspx?ReturnUrl=/Aktuell/Intern/Stundenplaene/schueler/stu1.aspx"
        break
      default:
        url = "http://elg-halle.de/Aktuell/Intern/Stundenplaene/Klassen/Kla1A_" + grades[grade - 1] + ".htm"
        break
      }
      
      // Check schedule URL
      
      if url == "http://www.elg-halle.de/Aktuell/Intern/default.aspx?ReturnUrl=/Aktuell/Intern/Stundenplaene/schueler/stu1.aspx" {
        // Check contraction
        
        if token != "" {
          // Update schedule URL
          
          url = "http://www.elg-halle.de/Aktuell/Intern/default.aspx?ReturnUrl=/Aktuell/Intern/Stundenplaene/schueler/stu1_" + token! + ".aspx"
        }
      }
      
      // Load schedule URL
      
      scheduleWebView.loadRequest(URLRequest(url: URL(string: url)!))
    } else {
      // Load No Internet Connection website
      
      scheduleWebView.loadRequest(URLRequest(url: Bundle.main.url(forResource: "NoConnection", withExtension: ".html")!))
    }
  }
}
