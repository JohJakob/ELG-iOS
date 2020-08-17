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

class NewsViewController: UIViewController {
	// MARK: - Properties
	
	var webView: WKWebView!
	
	let urlString = "https://elg-halle.de/Aktuell/News/news.asp"
	
	fileprivate let refreshControl = UIRefreshControl()
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
		
		// Create web view
		webView = WKWebView()
		webView.navigationDelegate = self
		
		// Check internet connection
		connectivity.checkConnectivity() { connectivity in
			switch connectivity.status {
				case .connected, .connectedViaWiFi, .connectedViaCellular:
					self.view.addSubview(self.webView)
				case .notConnected, .connectedViaWiFiWithoutInternet, .connectedViaCellularWithoutInternet:
					self.notConnectedView = NotConnectedView(frame: self.view.bounds)
					self.notConnectedView.tag = self.notConnectedViewTag
					self.view.addSubview(self.notConnectedView)
				case .determining:
					self.view.addSubview(self.webView)
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
}

extension NewsViewController: WKNavigationDelegate {
	
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
