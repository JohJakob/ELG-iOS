//
//  WebScheduleViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 27/06/2016
//  ©2016 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class WebScheduleViewController: UIViewController, UIWebViewDelegate {
  // Outlets
  
  @IBOutlet weak private var scheduleWebView: UIWebView!
  @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
  
  // Variables + constants
  
  let reachabilityStatus: NetworkStatus = Reachability.reachabilityForInternetConnection().currentReachabilityStatus()
  var defaults: NSUserDefaults!
  let grades = ["5a", "5b", "5c", "5d", "5e", "6a", "6b", "6c", "6d", "6e", "7a", "7b", "7c", "7d", "8a", "8b", "8c", "8d", "9a", "9b", "9c", "9d", "10a", "10b", "10c", "10d"]
  var url: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
    
    if #available(iOS 8, *) {
      defaults = NSUserDefaults.standardUserDefaults()
    } else {
      defaults = NSUserDefaults.init(suiteName: "group.com.hardykrause.elg")
    }
    
    loadSchedule()
  }
  
  // Web View functions
  
  func webViewDidStartLoad(webView: UIWebView) {
    // Start Activity Indicator
    
    activityIndicator.startAnimating()
  }
  
  func webViewDidFinishLoad(webView: UIWebView) {
    // Stop Activity Indicator
    
    activityIndicator.stopAnimating()
    
    // Get user defaults
    
    let username = defaults.stringForKey("username")
    let password = defaults.stringForKey("password")
    
    // Check Internet reachability
    
    if reachabilityStatus != NotReachable {
      // Get grade user default
      
      let grade = defaults.integerForKey("grade")
      
      // Log in and load individual schedule website
      
      if grade > 25 {
        if username != "" || password != "" {
          // Create JavaScript
          
          let fillUsernameScript = "var inputFields = document.getElementsByTagName('input'); for (var i = inputFields.length >>> 0; i--;) { if (inputFields[i].name == 'txtBenutzername') { inputFields[i].value = '" + username! + "'; } }"
          let fillPasswordScript = "for (var i = inputFields.length >>> 0; i--;) { if (inputFields[i].name == 'txtKennwort') { inputFields[i].value = '" + password! + "'; } }"
          let loginScript = "document.getElementById('btnAnmelden').click();"
          
          // Execute JavaScript in Web View
          
          scheduleWebView.stringByEvaluatingJavaScriptFromString(fillUsernameScript)
          scheduleWebView.stringByEvaluatingJavaScriptFromString(fillPasswordScript)
          scheduleWebView.stringByEvaluatingJavaScriptFromString(loginScript)
        }
      }
    }
  }
  
  func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
    // Stop Activity Indicator
    
    activityIndicator.stopAnimating()
    
    // Show alert
    
    let webViewErrorAlert = UIAlertView(title: "Fehler", message: "Beim Laden ist ein Fehler aufgetreten.", delegate: self, cancelButtonTitle: "OK")
    webViewErrorAlert.show()
  }
  
  // Custom functions
  
  func loadSchedule() {
    // Set Web View delegate
    
    scheduleWebView.delegate = self
    
    // Check Internet reachability
    
    if reachabilityStatus != NotReachable {
      // Get user defaults
      
      let grade = defaults.integerForKey("grade")
      let token = defaults.stringForKey("token")
      
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
      
      scheduleWebView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
    } else {
      // Load No Internet Connection website
      
      scheduleWebView.loadRequest(NSURLRequest(URL: NSBundle.mainBundle().URLForResource("NoConnection", withExtension: ".html")!))
      
      // Show alert
      
      let noConnectionAlert = UIAlertView(title: "Keine Internetverbindung", message: "Es besteht keine Verbindung zum Internet. Bitte überprüfe Deine Einstellungen.", delegate: self, cancelButtonTitle: "OK")
      noConnectionAlert.show()
    }
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
