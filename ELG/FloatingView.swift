//
//  FloatingView.swift
//  ELG
//
//  Created by Johannes Jakob on 28/07/2017
//  © 2017 Brian Coyner, Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class FloatingView: UIView {
	fileprivate enum Properties {
		static let cornerRadius: CGFloat = 10
		static let shadow: Shadow = Shadow(color: .lightGray, offset: CGSize(), blur: 6)
	}
	
	var contentView: UIView {
		return visualEffectView.contentView
	}
	
	var showCapInsetLines: Bool = false {
		didSet {
			shadowView.image = resizableShadowImage(
				withCornerRadius: Properties.cornerRadius,
				shadow: Properties.shadow,
				shouldDrawCapInsets: showCapInsetLines
			)
		}
	}
	
	var showShadow: Bool = true {
		didSet {
			shadowView.isHidden = !showShadow
		}
	}
	
	fileprivate lazy var shadowView: UIImageView = self.lazyShadowView()
	fileprivate lazy var visualEffectView: UIVisualEffectView = self.lazyVisualEffectView()
	
	convenience init() {
		self.init(frame: CGRect())
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.selfInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.selfInit()
	}
	
	private func selfInit() {
		backgroundColor = .clear
		
		addSubview(shadowView)
		addSubview(visualEffectView)
		
		let blurRadius = Properties.shadow.blur
		
		if #available(iOS 9, *) {
			NSLayoutConstraint.activate([
				visualEffectView.topAnchor.constraint(equalTo: topAnchor),
				visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
				visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
				visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
				
				shadowView.topAnchor.constraint(equalTo: topAnchor, constant: -blurRadius),
				shadowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: blurRadius),
				shadowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: blurRadius),
				shadowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -blurRadius),
			])
		}
	}
}

extension FloatingView {
	fileprivate func lazyVisualEffectView() -> UIVisualEffectView {
		let view = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
		
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = Properties.cornerRadius
		view.layer.masksToBounds = true
		
		return view
	}
	
	fileprivate func lazyShadowView() -> UIImageView {
		let image = resizableShadowImage(
			withCornerRadius: Properties.cornerRadius,
			shadow: Properties.shadow,
			shouldDrawCapInsets: showCapInsetLines
		)
		
		let view = UIImageView(image: image)
		
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}
	
	fileprivate func resizableShadowImage(
		withCornerRadius cornerRadius: CGFloat,
		shadow: Shadow,
		shouldDrawCapInsets: Bool
	) -> UIImage {
		let sideLength: CGFloat = cornerRadius * 5
		
		return UIImage.resizableShadowImage(
			withSideLength: sideLength,
			cornerRadius: cornerRadius,
			shadow: shadow,
			shouldDrawCapInsets: showCapInsetLines
		)
	}
}
