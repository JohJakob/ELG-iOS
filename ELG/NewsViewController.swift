//
//  NewsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 24/06/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

final class NewsViewController: UIViewController, UIWebViewDelegate {
  // MARK: - Properties
	
	@IBOutlet weak fileprivate var newsWebView: UIWebView!
	@IBOutlet weak fileprivate var segmentedControl: UISegmentedControl!
  @IBOutlet weak fileprivate var activityIndicator: UIActivityIndicatorView!
	
	fileprivate lazy var navigationButtonView: FloatingView = self.lazyFloatingView()
	var backButton = UIButton()
	var forwardButton = UIButton()
	let foerdervereinViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FoerdervereinTableViewController")
	
	// MARK: - UIViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
		
		initialize()
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
		
		if (newsWebView.canGoBack || newsWebView.canGoForward) || (newsWebView.canGoBack && newsWebView.canGoForward) {
			navigationButtonView.isHidden = false
		} else {
			if navigationButtonView.isHidden == false {
				navigationButtonView.isHidden = true
			}
		}
  }
  
  func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    activityIndicator.stopAnimating()
		
    let webViewErrorAlert = UIAlertView(title: "Fehler", message: "Beim Laden ist ein Fehler aufgetreten.", delegate: self, cancelButtonTitle: "OK")
    webViewErrorAlert.show()
  }
  
  // MARK: - Private
	
	private func initialize() {
		segmentedControl.addTarget(self, action: #selector(NewsViewController.changeView), for: .valueChanged)
		
		view.addSubview(navigationButtonView)
		
		NSLayoutConstraint.activate([
			NSLayoutConstraint(item: navigationButtonView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 92),
			NSLayoutConstraint(item: navigationButtonView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 46),
			
			NSLayoutConstraint(item: navigationButtonView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20),
			NSLayoutConstraint(item: navigationButtonView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: -20)
			])
		
		navigationButtonView.isHidden = true
		
		loadNews()
		
		let defaults = UserDefaults.init(suiteName: "group.com.hardykrause.elg")
		
		if defaults?.integer(forKey: "startView") == 1 {
			segmentedControl.selectedSegmentIndex = 1
			
			changeView()
		}
	}
  
  private func loadNews() {
    newsWebView.delegate = self
		
    let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      newsWebView.loadRequest(URLRequest(url: URL(string: "http://elg-halle.de/Aktuell/News/news.asp")!))
    } else {
      newsWebView.loadRequest(URLRequest(url: Bundle.main.url(forResource: "NoConnection", withExtension: ".html")!))
    }
  }
	
	@objc private func changeView() {
		var navigationStack = navigationController?.viewControllers
		
		navigationStack?.remove(at: (navigationStack!.count) - 1)
		navigationStack?.insert(foerdervereinViewController, at: (navigationStack?.count)!)
		navigationController?.setViewControllers(navigationStack!, animated: false)
	}
}

extension NewsViewController {
	fileprivate func lazyFloatingView() -> FloatingView {
		let view = FloatingView()
		
		view.translatesAutoresizingMaskIntoConstraints = false
		
		addContent(to: view.contentView)
		
		return view
	}
	
	fileprivate func addContent(to contentView: UIView) {
		backButton.addTarget(newsWebView, action: #selector(newsWebView.goBack), for: .touchUpInside)
		backButton.setImage(#imageLiteral(resourceName: "Back"), for: .normal)
		backButton.setImage(#imageLiteral(resourceName: "Back-Disabled"), for: .disabled)
		backButton.translatesAutoresizingMaskIntoConstraints = false
		
		forwardButton.addTarget(newsWebView, action: #selector(newsWebView.goForward), for: .touchUpInside)
		forwardButton.setImage(#imageLiteral(resourceName: "Forward"), for: .normal)
		forwardButton.setImage(#imageLiteral(resourceName: "Forward-Disabled"), for: .disabled)
		forwardButton.translatesAutoresizingMaskIntoConstraints = false
		
		let separator = UIView.init()
		
		separator.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
		separator.translatesAutoresizingMaskIntoConstraints = false
		
		contentView.addSubview(backButton)
		contentView.addSubview(forwardButton)
		contentView.addSubview(separator)
		
		NSLayoutConstraint.activate([
			NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 45),
			NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 46),
			
			NSLayoutConstraint(item: backButton, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: backButton, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
			
			NSLayoutConstraint(item: forwardButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 45),
			NSLayoutConstraint(item: forwardButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 46),
			
			NSLayoutConstraint(item: forwardButton, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: forwardButton, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: forwardButton, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
			
			NSLayoutConstraint(item: separator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1),
			NSLayoutConstraint(item: separator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 46),
			
			NSLayoutConstraint(item: separator, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: separator, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: separator, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
		])
	}
}
