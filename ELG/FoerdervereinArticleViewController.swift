//
//  FoerdervereinArticleViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 13/08/2016
//  © 2016-2018 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class FoerdervereinArticleViewController: UIViewController, WKNavigationDelegate {
  // MARK: - Properties
	
  var defaults: UserDefaults!
	var backButton = UIButton()
	var forwardButton = UIButton()
  var articleTitle = String()
  var articleLink = String()
	fileprivate lazy var navigationButtonView: FloatingView = self.lazyFloatingView()
	var webView = WKWebView()
	var refreshing = false
	let activityIndicator = UIActivityIndicatorView()
	let refreshControl = UIRefreshControl()
	
	// MARK: - Initializers
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		initialize()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		initialize()
	}
	
	// MARK: - UIViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
		
		initialize()
		
    loadArticle()
  }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
	// MARK: - WKWebView
	
	func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
		if refreshing == false {
			activityIndicator.startAnimating()
		}
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		activityIndicator.stopAnimating()
		refreshControl.endRefreshing()
		
		if webView.canGoBack {
			backButton.isEnabled = true
		} else {
			backButton.isEnabled = false
		}
		
		if webView.canGoForward {
			forwardButton.isEnabled = true
		} else {
			forwardButton.isEnabled = false
		}
		
		if (webView.canGoBack || webView.canGoForward) || (webView.canGoBack && webView.canGoForward) {
			navigationButtonView.isHidden = false
		} else {
			if navigationButtonView.isHidden == false {
				navigationButtonView.isHidden = true
			}
		}
		
		refreshing = false
	}
	
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		activityIndicator.stopAnimating()
		refreshControl.endRefreshing()
		
		refreshing = false
		
		let webViewErrorAlertController = UIAlertController(title: "Fehler", message: "Beim Laden ist ein Fehler aufgetreten.", preferredStyle: .alert)
		
		webViewErrorAlertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
			self.dismiss(animated: true, completion: nil)
		}))
		
		present(webViewErrorAlertController, animated: true, completion: nil)
	}
  
  // MARK: - Private
	
	private func initialize() {
		defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
		
		navigationItem.title = defaults.string(forKey: "selectedArticleTitle")
		
		webView = WKWebView(frame: view.frame)
		webView.translatesAutoresizingMaskIntoConstraints = false
		webView.navigationDelegate = self
		
		activityIndicator.style = .gray
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		
		refreshControl.addTarget(self, action: #selector(FoerdervereinArticleViewController.refresh), for: .valueChanged)
		
		webView.scrollView.addSubview(refreshControl)
		
		view.addSubview(webView)
		view.addSubview(activityIndicator)
		view.addSubview(navigationButtonView)
		
		NSLayoutConstraint.activate([
			NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: webView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: webView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
			
			NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0),
			
			NSLayoutConstraint(item: navigationButtonView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 92),
			NSLayoutConstraint(item: navigationButtonView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 46),
			
			NSLayoutConstraint(item: navigationButtonView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20),
			NSLayoutConstraint(item: navigationButtonView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: -20)
			])
		
		navigationButtonView.isHidden = true
	}
  
  private func loadArticle() {
    let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
		
    if reachabilityStatus != NotReachable {
      webView.load(URLRequest(url: URL(string: defaults.string(forKey: "selectedArticleLink")!)!))
    } else {
      webView.load(URLRequest(url: Bundle.main.url(forResource: "NoConnection", withExtension: ".html")!))
    }
  }
	
	@objc private func refresh() {
		refreshing = true
		
		loadArticle()
	}
}

extension FoerdervereinArticleViewController {
	fileprivate func lazyFloatingView() -> FloatingView {
		let view = FloatingView()
		
		view.translatesAutoresizingMaskIntoConstraints = false
		
		addContent(to: view.contentView)
		
		return view
	}
	
	fileprivate func addContent(to contentView: UIView) {
		backButton.addTarget(webView, action: #selector(webView.goBack), for: .touchUpInside)
		backButton.setImage(#imageLiteral(resourceName: "Back"), for: .normal)
		backButton.setImage(#imageLiteral(resourceName: "Back-Disabled"), for: .disabled)
		backButton.translatesAutoresizingMaskIntoConstraints = false
		
		forwardButton.addTarget(webView, action: #selector(webView.goForward), for: .touchUpInside)
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
