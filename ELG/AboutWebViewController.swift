//
//  AboutWebViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 27/11/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class AboutWebViewController: UIViewController, UIWebViewDelegate {
  // MARK: - Properties
  
  @IBOutlet weak fileprivate var aboutWebView: UIWebView!
  
  var defaults: UserDefaults!
  var selectedAboutWebView = Int()
  var didLaunch = Bool()
  let titles = ["Was ist neu?", "Open Source", "Impressum der Website"]
  let pages = ["ReleaseNotes", "OpenSource", "Imprint"]
  let onboardingViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OnboardingTableViewController")
  let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	
	// MARK: - UIViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
		
		defaults = UserDefaults.init(suiteName: "group.com.hardykrause.elg")
		
		// Set back indicator image
		
		navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Back")
		navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Back")
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		
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
  
  func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
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
      // Add button to navigation bar
      
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Fertig", style: .done, target: self, action: #selector(doneButtonTapped))
    }
  }
  
  func doneButtonTapped() {
		// Set user default
		
		defaults.set(true, forKey: "launched\(String(describing: version))")
		
		defaults.synchronize()
		
    // Dismiss view
		
		dismiss(animated: true, completion: nil)
		
		// navigationController?.show(onboardingViewController, sender: self)
  }
}
