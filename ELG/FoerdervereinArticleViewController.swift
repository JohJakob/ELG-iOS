//
//  FoerdervereinArticleViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 13/08/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class FoerdervereinArticleViewController: UIViewController, UIWebViewDelegate {
  // MARK: - Properties
  
  @IBOutlet weak fileprivate var articleWebView: UIWebView!
  @IBOutlet weak fileprivate var backButton: UIBarButtonItem!
  @IBOutlet weak fileprivate var forwardButton: UIBarButtonItem!
  @IBOutlet weak fileprivate var activityIndicator: UIActivityIndicatorView!
  
  var defaults: UserDefaults!
  var articleTitle = String()
  var articleLink = String()
	
	// MARK: - UIViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
		
		defaults = UserDefaults.init(suiteName: "group.com.hardykrause.elg")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Load article
    
    loadArticle()
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
    
    // Enable/Disable Back and Forward buttons
    
    if articleWebView.canGoBack {
      backButton.isEnabled = true
    } else {
      backButton.isEnabled = false
    }
    
    if articleWebView.canGoForward {
      forwardButton.isEnabled = true
    } else {
      forwardButton.isEnabled = false
    }
  }
  
  func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    // Stop Activity Indicator
    
    activityIndicator.stopAnimating()
    
    // Create and show alert
    
    let webViewErrorAlert = UIAlertView(title: "Fehler", message: "Beim Laden ist ein Fehler aufgetreten.", delegate: self, cancelButtonTitle: "OK")
    webViewErrorAlert.show()
  }
  
  // MARK: - Custom
  
  func loadArticle() {
    // Set web view delegate
    
    articleWebView.delegate = self
    
    // Check internet reachability
    
    let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      // Get article's title and link
      
      articleTitle = defaults.string(forKey: "selectedArticleTitle")!
      articleLink = defaults.string(forKey: "selectedArticleLink")!
      
      // Load news website
      
      articleWebView.loadRequest(URLRequest(url: URL(string: articleLink)!))
      
      // Set navigation item title
      
      navigationItem.title = articleTitle
    } else {
      // Load message website
      
      articleWebView.loadRequest(URLRequest(url: Bundle.main.url(forResource: "NoConnection", withExtension: ".html")!))
    }
  }
}
