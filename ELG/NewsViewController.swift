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
  
  // Variables
  
  let reachabilityStatus: NetworkStatus = Reachability.reachabilityForInternetConnection().currentReachabilityStatus()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set WebView delegate
    
    newsWebView.delegate = self
    
    // Check Internet reachability
    
    if reachabilityStatus != NotReachable {
      // Load News website
      
      self.newsWebView.loadRequest(NSURLRequest(URL: NSURL(string: "http://elg-halle.de/Aktuell/News/news.asp")!))
    }
  }
  
  // WebView functions
  
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
    
    // Show Alert
    
    let webViewErrorAlert = UIAlertView(title: "Fehler", message: "Beim Laden ist ein Fehler aufgetreten.", delegate: self, cancelButtonTitle: "OK")
    webViewErrorAlert.show()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
