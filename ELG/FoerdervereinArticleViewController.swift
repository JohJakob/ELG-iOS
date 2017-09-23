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
		
		defaults = UserDefaults.init(suiteName: "group.com.hardykrause.elg")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    loadArticle()
  }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
  // MARK: - UIWebView
  
  func webViewDidStartLoad(_ webView: UIWebView) {
    activityIndicator.startAnimating()
  }
  
  func webViewDidFinishLoad(_ webView: UIWebView) {
    activityIndicator.stopAnimating()
    
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
    activityIndicator.stopAnimating()
		
    let webViewErrorAlert = UIAlertView(title: "Fehler", message: "Beim Laden ist ein Fehler aufgetreten.", delegate: self, cancelButtonTitle: "OK")
    webViewErrorAlert.show()
  }
  
  // MARK: - Private
  
  private func loadArticle() {
    articleWebView.delegate = self
		
    let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      articleTitle = defaults.string(forKey: "selectedArticleTitle")!
      articleLink = defaults.string(forKey: "selectedArticleLink")!
			
      articleWebView.loadRequest(URLRequest(url: URL(string: articleLink)!))
			
      navigationItem.title = articleTitle
    } else {
      articleWebView.loadRequest(URLRequest(url: Bundle.main.url(forResource: "NoConnection", withExtension: ".html")!))
    }
  }
}
