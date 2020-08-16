//
//  AboutWebViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 27/11/2016
//  © Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class AboutWebViewController: UIViewController, UIWebViewDelegate {
  // MARK: - Properties
  
  @IBOutlet weak fileprivate var aboutWebView: UIWebView!
  
  var defaults: UserDefaults!
  var selectedAboutWebView = Int()
  var currentVersionKey = String()
  let titles = ["Was ist neu?", "Open Source", "Impressum", "Datenschutzerklärung"]
  let pages = ["ReleaseNotes", "OpenSource", "Imprint", "Privacy"]
  var onboardingViewController = UIViewController()
  let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	
	// MARK: - UIViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
		
		if #available(iOS 11, *) {
			onboardingViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OnboardingTableViewController")
		} else {
			onboardingViewController = UIStoryboard(name: "MainLegacy", bundle: Bundle.main).instantiateViewController(withIdentifier: "OnboardingTableViewController")
		}
    
    // Initialize user defaults
		defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
		
		// Set web view delegate
		aboutWebView.delegate = self
		
		// Check if this is the current version’s first launch
		
		// Create key name for current version
		currentVersionKey = "launched" + version!
		
		// Show release notes on first launch
		if defaults.object(forKey: currentVersionKey) == nil {
			selectedAboutWebView = 0
			
			// Add dismiss button
			createDismissButton()
		} else {
			getSelectedAboutWebView()
		}
		
		// Load web page
		loadPage()
  }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(true)
		
		// Complete onboarding when the view is dismissed by swiping down
		completeOnboarding()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
  // MARK: - UIWebView
  
	///
	/// Override the web view’s loading behavior
	///
  func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
    // Check if a hyperlink was tapped to open it in a browser
    if navigationType == .linkClicked {
      // Open URL in a browser
      UIApplication.shared.openURL(request.url!)
      
      return false
    }
		
    return true
  }
  
  // MARK: - Custom
	
	///
	/// Get selected view from user defaults
	///
	func getSelectedAboutWebView() {
		selectedAboutWebView = defaults.integer(forKey: "selectedAboutWebView")
	}
  
	///
	/// Load web page
	///
  func loadPage() {
    // Set navigation bar title
    navigationItem.title = titles[selectedAboutWebView]
    
    // Load web page
		aboutWebView.loadRequest(URLRequest(url: Bundle.main.url(forResource: pages[selectedAboutWebView], withExtension: ".html")!))
  }
	
	///
	/// Create dismiss button if the view was presented on the current version’s first launch
	///
	func createDismissButton() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Fertig", style: .done, target: self, action: #selector(dismissButtonTapped))
	}
	
	///
	/// Complete onboarding process on first launch
	///
	func completeOnboarding() {
		// Get user defaults key for previously launched version
		var previousVersionKey = String()
		
		if defaults.object(forKey: "previousVersionKeyName") != nil {
			previousVersionKey = defaults.string(forKey: "previousVersionKeyName")!
		}
		
		// Remove user defaults key for previously launched version
		if self.defaults.object(forKey: previousVersionKey) != nil {
			self.defaults.removeObject(forKey: previousVersionKey)
		}
		
		// Set user defaults for current version
		self.defaults.set(true, forKey: currentVersionKey)
		self.defaults.set(currentVersionKey, forKey: "previousVersionKeyName")
		
		self.defaults.synchronize()
	}
  
	///
	/// Handle the dismiss button action
	///
  @objc func dismissButtonTapped() {
    // Complete onboarding
		completeOnboarding()
		
    // Dismiss view
		dismiss(animated: true, completion: nil)
  }
}
