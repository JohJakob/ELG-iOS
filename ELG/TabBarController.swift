//
//  TabBarController.swift
//  ELG
//
//  Created by Johannes Jakob on 26/07/2017
//  © 2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class TabBarController: UITabBarController {
	// MARK: - Properties
	
	var defaults: UserDefaults!
	let onboardingViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OnboardingNavigationController")
	let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	
	// MARK: - UITabBarController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		defaults = UserDefaults.init(suiteName: "group.com.hardykrause.elg")
		
		setUp()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Delete user default from previous version
		
		defaults.removeObject(forKey: "launched2.0.1")
		
		// Check for first launch
		
		if defaults.bool(forKey: "launched\(String(describing: version))") != true {
			// Update user settings after first launch
			
			updateUserSettings()
		}
		
		// Show view based on URL query
		
		
		
		// Remove temporary user defaults
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
	// MARK: - Custom
	
	func setUp() {
		navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Back")
		navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Back")
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		
		// Set empty teacher token in UserDefaults if it is nil
		
		if defaults.string(forKey: "teacherToken") == nil {
			defaults.set("", forKey: "teacherToken")
		}
		
		defaults.synchronize()
	}
	
	func updateUserSettings() {
		// Check existing UserDefaults for the selected start view and update the values
		
		if defaults.integer(forKey: "startView") == 1 {
			defaults.set(0, forKey: "startView")
		} else if defaults.integer(forKey: "startView") == 4 {
			defaults.set(2, forKey: "startView")
		}
		
		defaults.synchronize()
		
		present(onboardingViewController, animated: true, completion: nil)
	}
}
