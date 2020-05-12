//
//  TabBarController.swift
//  ELG
//
//  Created by Johannes Jakob on 26/07/2017
//  © 2017-2018 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit
import SafariServices

class TabBarController: UITabBarController, SFSafariViewControllerDelegate {
	// MARK: - Properties
	
	var defaults: UserDefaults!
	let onboardingViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OnboardingNavigationController")
	let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	let grades = ["Keine Klasse", "5a", "5b", "5c", "5d", "5e", "6a", "6b", "6c", "6d", "6e", "7a", "7b", "7c", "7d", "7e", "8a", "8b", "8c", "8d", "8e", "9a", "9b", "9c", "9d", "9e", "10a", "10b", "10c", "10d", "10e", "11a", "11b", "11c", "11d", "11e", "12a", "12b", "12c", "12d", "12e"]
	let previousGrades = ["Keine Klasse", "5a", "5b", "5c", "5d", "5e", "6a", "6b", "6c", "6d", "6e", "7a", "7b", "7c", "7d", "7e", "8a", "8b", "8c", "8d","9a", "9b", "9c", "9d", "10a", "10b", "10c", "10d", "11a", "11b", "11c", "11d", "11e", "12a", "12b", "12c", "12d", "12e"]
	
	// MARK: - UITabBarController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
		
		setUp()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		defaults.removeObject(forKey: "launched3.0")
		
		if defaults.bool(forKey: "completedFeaturePoll") != true {
			presentFeaturePoll()
		}
		
		/* if defaults.bool(forKey: "launched\(String(describing: version))") != true {
			updateUserDefaults()
		} */
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
		// Check and update start view settings from previous version
		
		if defaults.integer(forKey: "startView") == 0 || defaults.integer(forKey: "startView") == 4 {
			defaults.set(0, forKey: "startView")
		} else {
			defaults.set(defaults.integer(forKey: "startView") - 1, forKey: "startView")
		}
		
		// Compare indices of grade settings in previous and current grade lists
		
		if previousGrades[defaults.integer(forKey: "selectedGrade")] != grades[defaults.integer(forKey: "selectedGrade")] {
			// Get index of previously selected grade in new grade list
			
			if let index = grades.firstIndex(of: previousGrades[defaults.integer(forKey: "selectedGrade")]) {
				let distance = grades.distance(from: grades.startIndex, to: index)
				
				// Update grade settings to match new grade list
				
				defaults.set(distance, forKey: "grade")
				
				// Remove old UserDefaults key
				
				defaults.removeObject(forKey: "selectedGrade")
			}
		}
		
		defaults.synchronize()
		
		present(onboardingViewController, animated: true, completion: nil)
	}
	
	private func presentFeaturePoll() {
		// Ask if user wants to complete a poll regarding the features of future versions of the app
		
		let pollAlert = UIAlertController(title: "Feature-Umfrage", message: "Danke, dass Du ELG verwendest! Um die App noch besser zu machen, benötige ich Dein Feedback. Möchtest Du eine kleine Umfrage (2-3 Minuten) beantworten?", preferredStyle: .alert)
		
		pollAlert.addAction(UIAlertAction(title: "Nein", style: .cancel, handler: nil))
		
		pollAlert.addAction(UIAlertAction(title: "Umfrage beantworten", style: .default, handler: { _ in
			let pollURLString = "https://johannesjakob.typeform.com/to/CNzyBw"
			
			if #available(iOS 9, *) {
				let pollSafariView = SFSafariViewController(url: URL(string: pollURLString)!)
				
				pollSafariView.delegate = self
				
				self.present(pollSafariView, animated: true, completion: nil)
			} else {
				UIApplication.shared.openURL(URL.init(string: pollURLString)!)
			}
		}))
		
		self.present(pollAlert, animated: true) {
			self.defaults.set(true, forKey: "completedFeaturePoll")
			self.defaults.set(true, forKey: "launched\(String(describing: self.version))")
		}
	}
}
