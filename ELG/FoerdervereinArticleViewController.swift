//
//  FoerdervereinArticleViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 13/08/2016
//  ©2016 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class FoerdervereinArticleViewController: UIViewController, UIWebViewDelegate {
  // Outlets
  
  @IBOutlet weak private var articleWebView: UIWebView!
  @IBOutlet weak private var backButton: UIBarButtonItem!
  @IBOutlet weak private var forwardButton: UIBarButtonItem!
  @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
  
  // Variables
  
  var defaults: NSUserDefaults!
  var articleTitle = String()
  var articleLink = String()
  
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
    
    // Load article
    
    loadArticle()
  }
  
  // Web View functions
  
  func webViewDidStartLoad(webView: UIWebView) {
    // Start Activity Indicator
    
    activityIndicator.startAnimating()
  }
  
  func webViewDidFinishLoad(webView: UIWebView) {
    // Stop Activity Indicator
    
    activityIndicator.stopAnimating()
    
    // Enable/Disable Back and Forward buttons
    
    if articleWebView.canGoBack {
      backButton.enabled = true
    } else {
      backButton.enabled = false
    }
    
    if articleWebView.canGoForward {
      forwardButton.enabled = true
    } else {
      forwardButton.enabled = false
    }
  }
  
  func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
    // Stop Activity Indicator
    
    activityIndicator.stopAnimating()
    
    // Create and show alert
    
    let webViewErrorAlert = UIAlertView(title: "Fehler", message: "Beim Laden ist ein Fehler aufgetreten.", delegate: self, cancelButtonTitle: "OK")
    webViewErrorAlert.show()
  }
  
  // Custom functions
  
  func loadArticle() {
    // Set web view delegate
    
    articleWebView.delegate = self
    
    // Check internet reachability
    
    let reachabilityStatus: NetworkStatus = Reachability.reachabilityForInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      // Get article's title and link
      
      articleTitle = defaults.stringForKey("selectedArticleTitle")!
      articleLink = defaults.stringForKey("selectedArticleLink")!
      
      // Load news website
      
      articleWebView.loadRequest(NSURLRequest(URL: NSURL(string: articleLink)!))
      
      // Set navigation item title
      
      navigationItem.title = articleTitle
    } else {
      // Load message website
      
      articleWebView.loadRequest(NSURLRequest(URL: NSBundle.mainBundle().URLForResource("NoConnection", withExtension: ".html")!))
      
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
