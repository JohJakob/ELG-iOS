//
//  ActionSheetPresentationControllerPickerViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 24/08/2017
//  © Caleb Davenport, Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

final class ActionSheetPresentationControllerPickerViewController: UIViewController {
	// MARK: - Properties
	
	let pickerView = UIPickerView()
	
	// MARK: - Initializers
	
	init() {
		super.init(nibName: nil, bundle: nil)
		
		modalPresentationStyle = .custom
		transitioningDelegate = self
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		pickerView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(pickerView)
		
		NSLayoutConstraint.activate([
			NSLayoutConstraint(item: pickerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: pickerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: pickerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: pickerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
		])
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

extension ActionSheetPresentationControllerPickerViewController: UIViewControllerTransitioningDelegate {
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		return ActionSheetPresentationController(presentedViewController: presented, presenting: presenting)
	}
}
