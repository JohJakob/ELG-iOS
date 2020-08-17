//
//  TabBarController.swift
//  ELG
//
//  Created by Johannes Jakob on 16/08/2020
//  © 2020 Johannes Jakob
//

///
/// Root view controller on iPhone
///

import UIKit

class TabBarController: UITabBarController {
	// MARK: - Properties
	
	// Tab view controllers
	let tabViews = [NewsTabViewController(), ScheduleCollectionViewController(), CoverPlanViewController(), SettingsViewController()]
	let tabViewTitles = ["News", "Schedule", "Cover Plan", "Settings"]
	let tabViewImageNames = ["NewsTab", "ScheduleTab", "CoverPlanTab", "SettingsTab"]
	
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		createTabs()
	}
	
	// MARK: - Private
	
	private func createTabs() {
		var tabViewList = [UIViewController]()
		
		for (index, view) in tabViews.enumerated() {
			let navigationController = UINavigationController()
			
			navigationController.viewControllers = [view]
			navigationController.tabBarItem = UITabBarItem(title: NSLocalizedString(tabViewTitles[index], comment: ""), image: UIImage(named: tabViewImageNames[index]), tag: index)
			
			tabViewList.append(navigationController)
		}
		
		// Set view controllers for tabs
		viewControllers = tabViewList
	}
}
