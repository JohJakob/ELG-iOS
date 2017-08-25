//
//  ActionSheetPresentationControllerDismissButton.swift
//  ELG
//
//  Created by Johannes Jakob on 18/08/2017
//  © 2017 Caleb Davenport, Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

final class ActionSheetPresentationControllerDismissButton: UIControl {
	// MARK: - Properties
	
	private let textLabel: UILabel = {
		let view = UILabel()
		
		if #available(iOS 8.2, *) {
			view.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightSemibold)
		} else {
			view.font = UIFont.boldSystemFont(ofSize: 20)
		}
		view.text = "Fertig"
		view.textAlignment = .center
		
		return view
	}()
	
	override var intrinsicContentSize: CGSize {
		return CGSize(width: UIViewNoIntrinsicMetric, height: 57)
	}
	
	// MARK: - Initializers
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setUp()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		setUp()
	}
	
	// MARK: - UIView
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		textLabel.frame = bounds
	}
	
	override func tintColorDidChange() {
		super.tintColorDidChange()
		
		textLabel.textColor = UIColor.init(red: 0.498, green: 0.09, blue: 0.204, alpha: 1)
	}
	
	// MARK: - Private
	
	private func setUp() {
		textLabel.textColor = UIColor.init(red: 0.498, green: 0.09, blue: 0.204, alpha: 1)
		
		addSubview(textLabel)
	}
}
