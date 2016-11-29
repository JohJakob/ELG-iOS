//
//  AboutWebViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 27/11/2016
//  © 2016 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class AboutWebViewController: UIViewController, UIWebViewDelegate {
  // Outlets
  
  @IBOutlet weak private var aboutWebView: UIWebView!
  
  // Variables + constants
  
  var defaults: NSUserDefaults!
  var selectedAboutWebView = Int()
  let titles = ["Was ist neu?", "Open Source", "Impressum"]
  let pages = ["ReleaseNotes", "OpenSource", "Imprint"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
    
    if #available(iOS 8, *) {
      defaults = NSUserDefaults.standardUserDefaults()
    } else {
      defaults = NSUserDefaults.init(suiteName: "group.com.hardykrause.elg")
    }
    
    retrieveUserDefault()
    
    loadPage()
  }
  
  // Web view functions
  
  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    // Check web view navigation type
    
    if navigationType == .LinkClicked {
      // Open URL in shared app
      
      UIApplication.sharedApplication().openURL(request.URL!)
      
      return false
    }
    
    return true
  }
  
  // Custom functions
  
  func retrieveUserDefault() {
    selectedAboutWebView = defaults.integerForKey("selectedAboutWebView")
  }
  
  func loadPage() {
    // Set navigation bar title
    
    navigationItem.title = titles[selectedAboutWebView]
    
    // Load page
    
    aboutWebView.loadRequest(NSURLRequest(URL: NSBundle.mainBundle().URLForResource(pages[selectedAboutWebView], withExtension: ".html")!))
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
