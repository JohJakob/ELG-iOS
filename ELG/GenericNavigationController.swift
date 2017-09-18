//
//  GenericNavigationController.swift
//  ELG
//
//  Created by Johannes Jakob on 18/09/2017
//  © 2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class GenericNavigationController: UINavigationController {
	// MARK: - UINavigationController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if SYSTEM_VERSION_LESS_THAN(version: "11.0") {
			navigationBar.backIndicatorImage = UIImage(named: "BackIndicator")
			navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "BackIndicatorMask")
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
	// MARK: - Private
	
	private func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
		return UIDevice.current.systemVersion.compare(version, options: .numeric) == ComparisonResult.orderedAscending
	}
}
