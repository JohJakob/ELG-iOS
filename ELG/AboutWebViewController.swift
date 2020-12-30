//
//  AboutWebViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 27/11/2016
//  © Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit
import WebKit

class AboutWebViewController: UIViewController, WKNavigationDelegate {
  // MARK: - Properties
  
	fileprivate var aboutWebView = WKWebView()
	
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
		
		// Set up web view
		aboutWebView = WKWebView(frame: view.frame)
		aboutWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		aboutWebView.navigationDelegate = self
		
		// Add web view to view
		view.addSubview(aboutWebView)
		
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
	
  // MARK: - WKWebView
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		if navigationAction.navigationType == .linkActivated {
			if let url = navigationAction.request.url {
				decisionHandler(.cancel)
				UIApplication.shared.openURL(url)
			} else {
				decisionHandler(.allow)
			}
		} else {
			decisionHandler(.allow)
		}
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
		aboutWebView.load(URLRequest(url: Bundle.main.url(forResource: pages[selectedAboutWebView], withExtension: ".html")!))
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
