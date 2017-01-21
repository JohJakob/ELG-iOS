//
//  AboutWebViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 27/11/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class AboutWebViewController: UIViewController, UIWebViewDelegate {
  // Outlets
  
  @IBOutlet weak private var aboutWebView: UIWebView!
  
  // Variables + constants
  
  var defaults: NSUserDefaults!
  var selectedAboutWebView = Int()
  var didLaunch = Bool()
  let titles = ["Was ist neu?", "Open Source", "Impressum der Website"]
  let pages = ["ReleaseNotes", "OpenSource", "Imprint"]
  let onboardingViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("OnboardingTableViewController")
  let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
    
    if #available(iOS 8, *) {
      defaults = NSUserDefaults.standardUserDefaults()
    } else {
      defaults = NSUserDefaults.init(suiteName: "group.com.hardykrause.elg")
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // Retrieve user defaults
    
    retrieveUserDefaults()
    
    // Load page in web view
    
    loadPage()
    
    // Show button in navigation bar on first launch
    
    showFirstLaunchButton()
  }
  
  // Web view functions
  
  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    // Check web view navigation type
    
    if navigationType == .LinkClicked {
      // Open URL in shared app
      
      UIApplication.sharedApplication().openURL(request.URL!)
      
      return false
    }
    
    return true
  }
  
  // Custom functions
  
  func retrieveUserDefaults() {
    // Retrieve user defaults
    
    didLaunch = defaults.boolForKey("launched\(version)")
    selectedAboutWebView = defaults.integerForKey("selectedAboutWebView")
    
    // Check whether the app has been launched for the first time
    
    if !didLaunch {
      selectedAboutWebView = 0
    }
  }
  
  func loadPage() {
    // Set navigation bar title
    
    navigationItem.title = titles[selectedAboutWebView]
    
    // Load page
    
    if #available(iOS 8, *) {
      aboutWebView.loadRequest(NSURLRequest(URL: NSBundle.mainBundle().URLForResource(pages[selectedAboutWebView], withExtension: ".html")!))
    } else {
      if selectedAboutWebView == 0 {
        aboutWebView.loadRequest(NSURLRequest(URL: NSBundle.mainBundle().URLForResource("ReleaseNotes-iOS-7", withExtension: ".html")!))
      } else {
        aboutWebView.loadRequest(NSURLRequest(URL: NSBundle.mainBundle().URLForResource(pages[selectedAboutWebView], withExtension: ".html")!))
      }
    }
  }
  
  func showFirstLaunchButton() {
    // Check whether the app has been launched for the first time
    
    if !didLaunch {
      // Add button to navigation bar
      
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Weiter", style: .Plain, target: self, action: #selector(nextButtonTapped))
    }
  }
  
  func nextButtonTapped() {
    // Navigate to new view
    
    if #available(iOS 8, *) {
      navigationController?.showViewController(onboardingViewController, sender: self)
    } else {
      navigationController?.pushViewController(onboardingViewController, animated: true)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
