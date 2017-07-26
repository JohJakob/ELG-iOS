//
//  TabBarController.swift
//  ELG
//
//  Created by Johannes Jakob on 26/07/2017
//  © 2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class TabBarController: UITabBarController {
	// MARK: Variables + constants
	
	var defaults: UserDefaults!
	var startView = Int()
	let onboardingViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OnboardingNavigationController")
	let startViewControllers = ["NewsNavigationController", "ScheduleNavigationController", "OmissionsNavigationController", "FoerdervereinNavigationController"]
	let lessonsViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LessonsTableViewController")
	let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Initialize user defaults
		
		defaults = UserDefaults.init(suiteName: "group.com.hardykrause.elg")
		
		// Set up app
		
		setUp()
		
		// Show start view
	}
	
	// MARK: Custom functions
	
	func setUp() {
		// Set back indicator image
		
		navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Back")
		navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Back")
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
	}
	
	func showStartView() {
		// Get user default
		
		startView = defaults.integer(forKey: "startView")
		
		// Show start view based on user setting
		
		if startView != 0 {
			if startView == 2 {
				// Get current weekday
				
				let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)
				let dateComponents = (gregorianCalendar! as NSCalendar).components(.weekday, from: Date())
				
				if dateComponents.weekday != 1 && dateComponents.weekday != 7 {
					// Set user default
					
					defaults.set(dateComponents.weekday! - 2, forKey: "selectedDay")
					defaults.synchronize()
					
					// Show start view
					
					showDetailViewController(lessonsViewController, sender: self)
				} else {
					// Set user default
					
					defaults.set(0, forKey: "selectedDay")
					defaults.synchronize()
					
					// Show start view
					
					showDetailViewController(lessonsViewController, sender: self)
				}
			} else {
				// Show start view
				
				showDetailViewController(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: startViewControllers[startView - 1]), sender: self)
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
}
