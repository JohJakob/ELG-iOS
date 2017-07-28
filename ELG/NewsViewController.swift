//
//  NewsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 24/06/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class NewsViewController: UIViewController, UIWebViewDelegate {
  // Outlets
	
	@IBOutlet weak fileprivate var segmentedControl: UISegmentedControl!
  @IBOutlet weak fileprivate var newsWebView: UIWebView!
  @IBOutlet weak fileprivate var backButton: UIBarButtonItem!
  @IBOutlet weak fileprivate var forwardButton: UIBarButtonItem!
  @IBOutlet weak fileprivate var activityIndicator: UIActivityIndicatorView!
	
	// Constants
	
	let foerdervereinViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FoerdervereinTableViewController")
  
  override func viewDidLoad() {
    super.viewDidLoad()
		
		segmentedControl.addTarget(self, action: #selector(NewsViewController.changeView), for: .valueChanged)

    // Load news in web view
    
    loadNews()
  }
  
  // Web View functions
  
  func webViewDidStartLoad(_ webView: UIWebView) {
    // Start Activity Indicator
    
    activityIndicator.startAnimating()
  }
  
  func webViewDidFinishLoad(_ webView: UIWebView) {
    // Stop Activity Indicator
    
    activityIndicator.stopAnimating()
    
    // Enable/Disable Back and Forward buttons
    
    if newsWebView.canGoBack {
      backButton.isEnabled = true
    } else {
      backButton.isEnabled = false
    }
    
    if newsWebView.canGoForward {
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
  
  // Custom functions
  
  func loadNews() {
    // Set web view delegate
    
    newsWebView.delegate = self
    
    // Check internet reachability
    
    let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      // Load news website
      
      newsWebView.loadRequest(URLRequest(url: URL(string: "http://elg-halle.de/Aktuell/News/news.asp")!))
    } else {
      // Load message website
      
      newsWebView.loadRequest(URLRequest(url: Bundle.main.url(forResource: "NoConnection", withExtension: ".html")!))
      
      // Show alert
      
      let noConnectionAlert = UIAlertView(title: "Keine Internetverbindung", message: "Es besteht keine Verbindung zum Internet. Bitte überprüfe Deine Einstellungen.", delegate: self, cancelButtonTitle: "OK")
      noConnectionAlert.show()
    }
  }
	
	func changeView() {
		var navigationStack = navigationController?.viewControllers
		
		navigationStack?.remove(at: (navigationStack!.count) - 1)
		navigationStack?.insert(foerdervereinViewController, at: (navigationStack?.count)!)
		navigationController?.setViewControllers(navigationStack!, animated: false)
	}
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
