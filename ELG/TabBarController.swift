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
		
		defaults.removeObject(forKey: "launched2.0.1")
		
		if defaults.bool(forKey: "launched\(String(describing: version))") != true {
			updateUserDefaults()
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
	
	private func updateUserDefaults() {
		if defaults.integer(forKey: "startView") == 1 {
			defaults.set(0, forKey: "startView")
		} else if defaults.integer(forKey: "startView") == 4 {
			defaults.set(2, forKey: "startView")
		}
		
		defaults.synchronize()
		
		present(onboardingViewController, animated: true, completion: nil)
	}
}
