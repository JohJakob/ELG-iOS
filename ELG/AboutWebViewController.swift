//
//  AboutWebViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 27/11/2016
//  © 2016-2018 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class AboutWebViewController: UIViewController, UIWebViewDelegate {
  // MARK: - Properties
  
  @IBOutlet weak fileprivate var aboutWebView: UIWebView!
  
  var defaults: UserDefaults!
  var selectedAboutWebView = Int()
  var didLaunch = Bool()
  let titles = ["Was ist neu?", "Open Source", "Impressum"]
  let pages = ["ReleaseNotes", "OpenSource", "Imprint"]
  let onboardingViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OnboardingTableViewController")
  let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	
	// MARK: - UIViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
		
		defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
		
		// Set web view's delegate
		
		aboutWebView.delegate = self
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
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
  // MARK: - UIWebView
  
  func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
    // Check web view navigation type

    if navigationType == .linkClicked {
      // Open URL in shared app
      
      UIApplication.shared.openURL(request.url!)
      
      return false
    }
		
    return true
  }
  
  // MARK: - Custom
  
  func retrieveUserDefaults() {
    // Retrieve user defaults
    
		didLaunch = defaults.bool(forKey: "launched\(String(describing: version))")
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
		
		aboutWebView.loadRequest(URLRequest(url: Bundle.main.url(forResource: pages[selectedAboutWebView], withExtension: ".html")!))
  }
  
  func showFirstLaunchButton() {
    // Check whether the app has been launched for the first time
    
    if !didLaunch {
      /* navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Weiter", style: .plain, target: self, action: #selector(nextButtonTapped)) */
			
			// Add button to navigation bar
			
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Fertig", style: .done, target: self, action: #selector(doneButtonTapped))
    }
  }
  
  @objc func doneButtonTapped() {
		// Set user default
    
		defaults.set(true, forKey: "launched\(String(describing: version))")
		
		defaults.synchronize()
    
    // Dismiss view
		
		dismiss(animated: true, completion: nil)
  }
}
