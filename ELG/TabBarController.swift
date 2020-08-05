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
	
	let weekdays = ["monday", "tuesday", "wednesday", "thursday", "friday"]
	
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
			// Migrate schedule from previous version
			if defaults.bool(forKey: "migratedSchedule3.0.3") != true {
				migrateSchedule()
			}
			
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
	
	///
	/// Migrate schedule to work with new table view design in v3.0.3
	///
	private func migrateSchedule() {
		for day in weekdays {
			if defaults.object(forKey: day) != nil {
				var lessons = defaults.stringArray(forKey: day)
				var rooms = [String](repeating: "", count: lessons!.count)
				
				// Regular expression pattern to separate lesson and room from previous entries
				let regexPattern = #"([\w\-\s]+)(\s\((\d{1,3})\))?"#
				
				// Split lessons and rooms
				for (index, lesson) in lessons!.enumerated() {
					let results = matches(for: regexPattern, in: lesson)
					
					if results.count == 2 {
						lessons![index] = results[0].trimmingCharacters(in: .whitespacesAndNewlines)
						rooms[index] = results[1]
					} else if results.count == 1 {
						lessons![index] = results[0].trimmingCharacters(in: .whitespacesAndNewlines)
						
						if defaults.object(forKey: day + "Rooms") != nil {
							rooms[index] = defaults.stringArray(forKey: day + "Rooms")![index]
						}
					}
				}
				
				defaults.set(lessons, forKey: day)
				defaults.set(rooms, forKey: day + "Rooms")
				
				// Save schedule migration completion in user defaults
				defaults.set(true, forKey: "migratedSchedule3.0.3")
				
				defaults.synchronize()
			}
		}
	}
	
	// MARK: - Utility
	
	func matches(for regex: String, in text: String) -> [String] {
		do {
			let regex = try NSRegularExpression(pattern: regex, options: [])
			let range = NSRange(text.startIndex..., in: text)
			
			let results = regex.matches(in: text, options: [], range: range).map {
				String(text[Range($0.range, in: text)!])
			}
			
			return results
    } catch let error {
			print("Invalid regular expression: \(error.localizedDescription)")
			
			return []
		}
	}
}
