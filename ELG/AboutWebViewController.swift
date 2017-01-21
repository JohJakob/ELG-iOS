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
  
  @IBOutlet weak fileprivate var aboutWebView: UIWebView!
  
  // Variables + constants
  
  var defaults: UserDefaults!
  var selectedAboutWebView = Int()
  var didLaunch = Bool()
  let titles = ["Was ist neu?", "Open Source", "Impressum der Website"]
  let pages = ["ReleaseNotes", "OpenSource", "Imprint"]
  let onboardingViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OnboardingTableViewController")
  let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
		
		defaults = UserDefaults.standard
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Retrieve user defaults
    
    retrieveUserDefaults()
    
    // Load page in web view
    
    loadPage()
    
    // Show button in navigation bar on first launch
    
    showFirstLaunchButton()
  }
  
  // Web view functions
  
  func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    // Check web view navigation type
    
    if navigationType == .linkClicked {
      // Open URL in shared app
      
      UIApplication.shared.openURL(request.url!)
      
      return false
    }
    
    return true
  }
  
  // Custom functions
  
  func retrieveUserDefaults() {
    // Retrieve user defaults
    
    didLaunch = defaults.bool(forKey: "launched\(version)")
    selectedAboutWebView = defaults.integer(forKey: "selectedAboutWebView")
    
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
      aboutWebView.loadRequest(URLRequest(url: Bundle.main.url(forResource: pages[selectedAboutWebView], withExtension: ".html")!))
    } else {
      if selectedAboutWebView == 0 {
        aboutWebView.loadRequest(URLRequest(url: Bundle.main.url(forResource: "ReleaseNotes-iOS-7", withExtension: ".html")!))
      } else {
        aboutWebView.loadRequest(URLRequest(url: Bundle.main.url(forResource: pages[selectedAboutWebView], withExtension: ".html")!))
      }
    }
  }
  
  func showFirstLaunchButton() {
    // Check whether the app has been launched for the first time
    
    if !didLaunch {
      // Add button to navigation bar
      
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Weiter", style: .plain, target: self, action: #selector(nextButtonTapped))
    }
  }
  
  func nextButtonTapped() {
    // Show new view
		
		navigationController?.show(onboardingViewController, sender: self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
