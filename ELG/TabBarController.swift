//
//  TabBarController.swift
//  ELG
//
//  Created by Johannes Jakob on 26/07/2017
//  © Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit
import SafariServices

class TabBarController: UITabBarController, SFSafariViewControllerDelegate {
	// MARK: - Properties
	
	var defaults: UserDefaults!
	var onboardingNavigationController = UINavigationController()
	let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	let grades = ["Keine Klasse", "5a", "5b", "5c", "5d", "5e", "6a", "6b", "6c", "6d", "6e", "7a", "7b", "7c", "7d", "7e", "8a", "8b", "8c", "8d", "8e", "9a", "9b", "9c", "9d", "9e", "10a", "10b", "10c", "10d", "10e", "11a", "11b", "11c", "11d", "11e", "12a", "12b", "12c", "12d", "12e"]
	
	// MARK: - UITabBarController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Initialize user defaults
		defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
		
		setUp()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Create key name for current version
		let currentVersionKey = "launched" + version!
		
		// Check if this is the current version’s first launch
		// Present release notes on first launch
		if defaults.object(forKey: currentVersionKey) == nil {
			if #available(iOS 11, *) {
				onboardingNavigationController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OnboardingNavigationController") as! UINavigationController
			} else {
				onboardingNavigationController = UIStoryboard(name: "MainLegacy", bundle: Bundle.main).instantiateViewController(withIdentifier: "OnboardingNavigationController") as! UINavigationController
			}
			
			present(onboardingNavigationController, animated: true, completion: nil)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
	// MARK: - Private
	
	private func setUp() {
		if defaults.string(forKey: "teacherToken") == nil {
			defaults.set("", forKey: "teacherToken")
		}
		
		defaults.synchronize()
	}
}
