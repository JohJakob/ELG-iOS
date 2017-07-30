//
//  NewsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 24/06/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

final class NewsViewController: UIViewController, UIWebViewDelegate {
  // MARK: Outlets
	
	@IBOutlet weak fileprivate var newsWebView: UIWebView!
	@IBOutlet weak fileprivate var segmentedControl: UISegmentedControl!
  @IBOutlet weak fileprivate var activityIndicator: UIActivityIndicatorView!
	
	// MARK: Variables + constants
	
	fileprivate lazy var navigationButtonView: FloatingView = self.lazyFloatingView()
	var backButton = UIButton()
	var forwardButton = UIButton()
	let foerdervereinViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FoerdervereinTableViewController")
  
  override func viewDidLoad() {
    super.viewDidLoad()
		
		// Add target to segmented control
		
		segmentedControl.addTarget(self, action: #selector(NewsViewController.changeView), for: .valueChanged)
		
		// Add navigation button view
		
		view.addSubview(navigationButtonView)
		
		// Activate layout constraints for navigation button view
		
		NSLayoutConstraint.activate([
			NSLayoutConstraint(item: navigationButtonView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 92),
			NSLayoutConstraint(item: navigationButtonView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 46),
			
			NSLayoutConstraint(item: navigationButtonView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20),
			NSLayoutConstraint(item: navigationButtonView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: -20)
		])
		
		// Hide navigation button view
		
		navigationButtonView.isHidden = true

    // Load news in web view
    
    loadNews()
  }
  
  // MARK: Web view functions
  
  func webViewDidStartLoad(_ webView: UIWebView) {
    // Start activity indicator
    
    activityIndicator.startAnimating()
  }
  
  func webViewDidFinishLoad(_ webView: UIWebView) {
    // Stop activity indicator
    
    activityIndicator.stopAnimating()
    
    // Enable/Disable back and forward buttons
    
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
		
		// Display navigation button view if navigation is possible
		
		if (newsWebView.canGoBack || newsWebView.canGoForward) || (newsWebView.canGoBack && newsWebView.canGoForward) {
			navigationButtonView.isHidden = false
		} else {
			if navigationButtonView.isHidden == false {
				navigationButtonView.isHidden = true
			}
		}
  }
  
  func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    // Stop activity indicator
    
    activityIndicator.stopAnimating()
    
    // Create and show alert
    
    let webViewErrorAlert = UIAlertView(title: "Fehler", message: "Beim Laden ist ein Fehler aufgetreten.", delegate: self, cancelButtonTitle: "OK")
    webViewErrorAlert.show()
  }
  
  // MARK: Custom functions
  
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

extension NewsViewController {
	fileprivate func lazyFloatingView() -> FloatingView {
		// Return floating view
		
		let view = FloatingView()
		
		view.translatesAutoresizingMaskIntoConstraints = false
		
		// Add content to floating view
		
		addContent(to: view.contentView)
		
		return view
	}
	
	fileprivate func addContent(to contentView: UIView) {
		// Set up back button
		
		backButton.addTarget(newsWebView, action: #selector(newsWebView.goBack), for: .touchUpInside)
		backButton.setImage(#imageLiteral(resourceName: "Back"), for: .normal)
		backButton.setImage(#imageLiteral(resourceName: "Back-Disabled"), for: .disabled)
		backButton.translatesAutoresizingMaskIntoConstraints = false
		
		// Set up forward button
		
		forwardButton.addTarget(newsWebView, action: #selector(newsWebView.goForward), for: .touchUpInside)
		forwardButton.setImage(#imageLiteral(resourceName: "Forward"), for: .normal)
		forwardButton.setImage(#imageLiteral(resourceName: "Forward-Disabled"), for: .disabled)
		forwardButton.translatesAutoresizingMaskIntoConstraints = false
		
		// Set up separator view
		
		let separator = UIView.init()
		
		separator.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
		separator.translatesAutoresizingMaskIntoConstraints = false
		
		// Add views to content view
		
		contentView.addSubview(backButton)
		contentView.addSubview(forwardButton)
		contentView.addSubview(separator)
		
		// Add layout constraints
		
		NSLayoutConstraint.activate([
			// Back button constraints
			
			NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 45),
			NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 46),
			
			NSLayoutConstraint(item: backButton, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: backButton, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
			
			// Forward button constraints
			
			NSLayoutConstraint(item: forwardButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 45),
			NSLayoutConstraint(item: forwardButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 46),
			
			NSLayoutConstraint(item: forwardButton, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: forwardButton, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: forwardButton, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
			
			// Separator view constraints
			
			NSLayoutConstraint(item: separator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1),
			NSLayoutConstraint(item: separator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 46),
			
			NSLayoutConstraint(item: separator, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: separator, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: separator, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
		])
	}
}
