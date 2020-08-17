//
//  NewsTabViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 16/08/2020
//  © 2020 Johannes Jakob
//

///
/// Tabman view for different news sources (Elisabeth-Gymnasium Halle, Förderverein, EliZE)
///

import UIKit
import Tabman
import Pageboy
import ColorCompatibility

class NewsTabViewController: TabmanViewController {
	// MARK: - Properties
	
	// Tab view controllers
	private var viewControllers = [NewsViewController(), FoerdervereinViewController(), ElizeViewController()]
	private let titles = ["News", "Friends' Association", "EliZE"]
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.dataSource = self
		
		// Create Tabman bar
		createTabBar()
	}
	
	// MARK: - Private
	
	///
	/// Create Tabman bar
	///
	private func createTabBar() {
		let bar = TMBar.ButtonBar();
		
		bar.backgroundView.style = .clear
		
		bar.layout.contentMode = .fit
		bar.layout.transitionStyle = .snap
		
		bar.scrollMode = .swipe
		
		bar.buttons.customize { (button) in
			button.font = .systemFont(ofSize: 15)
			button.tintColor = ColorCompatibility.secondaryLabel
			
			if #available(iOS 11, *) {
				button.selectedTintColor = UIColor(named: "AccentColor")
			} else {
				button.selectedTintColor = UIColor(red: 0.498, green: 0.09, blue: 0.204, alpha: 1)
			}
		}
		
		bar.indicator.weight = .light
		
		if #available(iOS 11, *) {
			bar.indicator.tintColor = UIColor(named: "AccentColor")
		} else {
			bar.indicator.tintColor = UIColor(red: 0.498, green: 0.09, blue: 0.204, alpha: 1)
		}
		
		addBar(bar, dataSource: self, at: .navigationItem(item: navigationItem))
	}
}

extension NewsTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
	func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
		return viewControllers.count
	}
	
	func viewController(for pageboyViewController: PageboyViewController,
											at index: PageboyViewController.PageIndex) -> UIViewController? {
		return viewControllers[index]
	}
	
	func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
		return nil
	}
	
	func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
		let title = NSLocalizedString(titles[index], comment: "")
		
		return TMBarItem(title: title)
	}
}
