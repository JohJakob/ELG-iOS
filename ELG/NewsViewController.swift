//
//  NewsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 24/06/2016
//  ©2016 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class NewsViewController: UIViewController, UIWebViewDelegate {
  // Outlets
  
  @IBOutlet weak private var newsWebView: UIWebView!
  @IBOutlet weak private var backButton: UIBarButtonItem!
  @IBOutlet weak private var forwardButton: UIBarButtonItem!
  @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    loadNews()
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
    
    if newsWebView.canGoBack {
      backButton.enabled = true
    } else {
      backButton.enabled = false
    }
    
    if newsWebView.canGoForward {
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
  
  func loadNews() {
    // Set web view delegate
    
    newsWebView.delegate = self
    
    // Check internet reachability
    
    let reachabilityStatus: NetworkStatus = Reachability.reachabilityForInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      // Load news website
      
      newsWebView.loadRequest(NSURLRequest(URL: NSURL(string: "http://elg-halle.de/Aktuell/News/news.asp")!))
    } else {
      // Load message website
      
      newsWebView.loadRequest(NSURLRequest(URL: NSBundle.mainBundle().URLForResource("NoConnection", withExtension: ".html")!))
      
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
