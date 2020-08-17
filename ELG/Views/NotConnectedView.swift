//
//  NotConnectedView.swift
//  ELG
//
//  Created by Johannes Jakob on 17/08/2020
//  © 2020 Johannes Jakob
//

///
/// View to display when there is no internet connection
///

import UIKit
import EasyPeasy
import ColorCompatibility

final class NotConnectedView: UIView {
	// MARK: - Properties
	
	let stackView: UIStackView = {
		let view = UIStackView()
		
		view.axis = .vertical
		view.alignment = .center
		view.distribution = .fill
		view.spacing = 6
		
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	public var headingLabel: UILabel = {
		let view = UILabel()
		
		view.font = .systemFont(ofSize: 18, weight: .bold)
		view.textColor = ColorCompatibility.secondaryLabel
		view.textAlignment = .center
		view.numberOfLines = 0
		view.lineBreakMode = .byWordWrapping
		
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	public var descriptionLabel: UILabel = {
		let view = UILabel()
				
		view.font = .systemFont(ofSize: 14)
		view.textColor = ColorCompatibility.secondaryLabel
		view.textAlignment = .center
		view.numberOfLines = 0
		
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	let defaultHeadingText = NSLocalizedString("No Internet Connection", comment: "")
	let defaultDescriptionText = NSLocalizedString("Please check your settings and try again.", comment: "")
	
	// MARK: - Initializers
	
	convenience init() {
		self.init(frame: CGRect())
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		createView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		createView()
	}
	
	// MARK: - UIView
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	// MARK: - Private
	
	private func createView() {
		autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
		
		headingLabel.text = defaultHeadingText
		descriptionLabel.text = defaultDescriptionText
		
		stackView.addArrangedSubview(headingLabel)
		stackView.addArrangedSubview(descriptionLabel)
		
		addSubview(stackView)
		
		stackView.easy.layout(
			Center(0),
			LeftMargin(16),
			RightMargin(16)
		)
	}
}
