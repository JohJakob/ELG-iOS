//
//  ActionSheetPresentationControllerSectionView.swift
//  ELG
//
//  Created by Johannes Jakob on 24/08/2017
//  © Caleb Davenport, Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

final class ActionSheetPresentationControllerSectionView: UIView {
	// MARK: - Properties
	
	private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
	
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
		
		visualEffectView.frame = bounds
	}
	
	// MARK: - Private
	
	private func setUp() {
		layer.masksToBounds = true
		layer.cornerRadius = 14
		
		if #available(iOS 13, *) {
			visualEffectView.effect = UIBlurEffect(style: .systemMaterial)
		}
		
		visualEffectView.isUserInteractionEnabled = false
		
		addSubview(visualEffectView)
	}
}
