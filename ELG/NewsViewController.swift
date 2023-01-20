//
//  NewsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 24/06/2016
//  © Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit
import WebKit
import ColorCompatibility

class NewsViewController: UIViewController, WKNavigationDelegate {
  // MARK: - Properties
	
	//@IBOutlet weak fileprivate var segmentedControl: UISegmentedControl!
  @IBOutlet weak fileprivate var activityIndicator: UIActivityIndicatorView!
	
	fileprivate var newsWebView = WKWebView()
	var refreshing = false
	//var foerdervereinViewController = UIViewController()
	let refreshControl = UIRefreshControl()
	
	// MARK: - UIViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
		
		// HACK: Force Navigation Bar to be translucent on iOS 15
		if #available(iOS 15, *) {
			let navigationBarAppearance = UINavigationBarAppearance()
			let tabBarAppearance = UITabBarAppearance()
			
			navigationBarAppearance.configureWithDefaultBackground()
			self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
			self.navigationController?.navigationBar.compactAppearance = navigationBarAppearance
			self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
			self.navigationController?.navigationBar.compactScrollEdgeAppearance = navigationBarAppearance
			
			tabBarAppearance.configureWithDefaultBackground()
			self.tabBarController?.tabBar.standardAppearance = tabBarAppearance
			self.tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearance
		}
		
		/*if #available(iOS 11, *) {
			foerdervereinViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FoerdervereinTableViewController")
		} else {
			foerdervereinViewController = UIStoryboard(name: "MainLegacy", bundle: Bundle.main).instantiateViewController(withIdentifier: "FoerdervereinTableViewController")
		}*/
		
		initialize()
  }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
  // MARK: - WKWebView
	
	func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
		if !refreshing {
			activityIndicator.startAnimating()
		}
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		activityIndicator.stopAnimating()
		refreshControl.endRefreshing()
		
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
		//segmentedControl.addTarget(self, action: #selector(changeView), for: .valueChanged)
		
		refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
		
		newsWebView = WKWebView(frame: view.frame)
		newsWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		newsWebView.navigationDelegate = self
		
		newsWebView.scrollView.addSubview(refreshControl)
		
		newsWebView.allowsBackForwardNavigationGestures = true
		
		view.addSubview(newsWebView)
		
		loadNews()
	}
  
  private func loadNews() {
    let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      newsWebView.load(URLRequest(url: URL(string: "https://www.ess-elisabeth.de/aktuelles/neuigkeiten")!))
			newsWebView.backgroundColor = UIColor.white
			
			refreshControl.tintColor = UIColor.lightGray
    } else {
      newsWebView.load(URLRequest(url: Bundle.main.url(forResource: "NoConnection", withExtension: ".html")!))
			newsWebView.backgroundColor = ColorCompatibility.systemBackground
			
			refreshControl.tintColor = nil
    }
  }
	
	/*@objc private func changeView() {
		var navigationStack = navigationController?.viewControllers
		var localNavigationStack = navigationStack
		
		navigationStack!.remove(at: (localNavigationStack!.count) - 1)
		
		localNavigationStack = navigationStack
		
		navigationStack!.insert(foerdervereinViewController, at: (localNavigationStack?.count)!)
		navigationController?.setViewControllers(navigationStack!, animated: false)
	}*/
	
	@objc private func refresh() {
		refreshing = true
		
		loadNews()
	}
}
