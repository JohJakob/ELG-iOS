//
//  NewsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 16/08/2020
//  © 2020 Johannes Jakob
//

///
/// Elisabeth-Gymnasium Halle news
///

import UIKit
import WebKit
import Connectivity
import EasyPeasy

class NewsViewController: UIViewController, WKUIDelegate {
	// MARK: - Properties
	
	var webView: WKWebView!
	var activityIndicator = UIActivityIndicatorView(style: .gray)
	var refreshControl = UIRefreshControl()
	
	var refreshing = false
	let urlString = "https://elg-halle.de/Aktuell/News/news.asp"
	
	fileprivate let connectivity: Connectivity = Connectivity()
	fileprivate var notConnectedView = NotConnectedView()
	fileprivate let notConnectedViewTag = 1
	
	// MARK: - Initializers
	
	deinit {
		connectivity.stopNotifier()
	}
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureConnectivityNotifier()
		startConnectivityChecks()
		
		// Set up web view
		let webConfiguration = WKWebViewConfiguration()
		webView = WKWebView(frame: .zero, configuration: webConfiguration)
		webView.uiDelegate = self
		webView.navigationDelegate = self
		webView.translatesAutoresizingMaskIntoConstraints = false
		webView.allowsBackForwardNavigationGestures = true
		
		// Set up activity indicator
		activityIndicator.hidesWhenStopped = true
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		
		// Set up refresh control
		refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
		webView.scrollView.addSubview(refreshControl)
		
		// Check internet connection
		connectivity.checkConnectivity() { connectivity in
			switch connectivity.status {
				case .connected, .connectedViaWiFi, .connectedViaCellular:
					self.addWebView()
				
					self.loadRequest()
				case .notConnected, .connectedViaWiFiWithoutInternet, .connectedViaCellularWithoutInternet:
					self.notConnectedView = NotConnectedView(frame: self.view.bounds)
					self.notConnectedView.tag = self.notConnectedViewTag
					self.view.addSubview(self.notConnectedView)
				case .determining:
					self.addWebView()
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		connectivity.stopNotifier()
	}
	
	// MARK: - Private
	
	///
	/// Load news page in web view
	///
	private func loadRequest() {
		let request = URLRequest(url: URL(string: urlString)!)
		
		webView.load(request)
	}
	
	@objc private func refresh() {
		refreshing = true
		
		loadRequest()
	}
	
	///
	/// Add web view and activity indicator to view
	///
	private func addWebView() {
		view.addSubview(webView)
		webView.easy.layout(Edges())
		
		view.addSubview(activityIndicator)
		activityIndicator.easy.layout(Center(0))
	}
	
	///
	/// Inject styles into web view to improve the pages’ appearance
	private func injectStyles(into webView: WKWebView) {
		guard let path = Bundle.main.path(forResource: "NewsStyles", ofType: "css") else { return }
		let rawCssString = try! String(contentsOfFile: path)
		let cssArray = rawCssString.components(separatedBy: .whitespacesAndNewlines)
		let cssString = cssArray.joined()
		let jsString = "var style = document.createElement(\"style\"); style.innerHTML = \"\(cssString)\"; document.head.appendChild(style);"
		
		webView.evaluateJavaScript(jsString, completionHandler: nil)
	}
}

extension NewsViewController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
		if !refreshing {
			activityIndicator.startAnimating()
		}
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		activityIndicator.stopAnimating()
		refreshControl.endRefreshing()
		
		refreshing = false
		
		// Inject styles
		injectStyles(into: webView)
	}
	
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		activityIndicator.stopAnimating()
		refreshControl.endRefreshing()
		
		refreshing = false
	}
}

///
/// Connectivity extension
///
private extension NewsViewController {
	func configureConnectivityNotifier() {
		let connectivityChanged: (Connectivity) -> Void = { [weak self] connectivity in
			self?.updateConnectionStatus(connectivity.status)
		}
		
		connectivity.whenConnected = connectivityChanged
	}
	
	func performSingleConnectivityCheck() {
		connectivity.checkConnectivity() { connectivity in
			self.updateConnectionStatus(connectivity.status)
		}
	}
	
	func startConnectivityChecks() {
		connectivity.startNotifier()
	}
	
	func stopConnectivityChecks() {
		connectivity.stopNotifier()
	}
	
	func updateConnectionStatus(_ status: Connectivity.Status) {
		switch status {
			case .connected, .connectedViaWiFi, .connectedViaCellular:
				if let viewWithTag = view.viewWithTag(notConnectedViewTag) {
					viewWithTag.removeFromSuperview()
					view.addSubview(webView)
				}
			case .notConnected, .connectedViaWiFiWithoutInternet, .connectedViaCellularWithoutInternet:
				break
			case .determining:
				break
		}
	}
}
