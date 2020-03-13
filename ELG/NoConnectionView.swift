//
//  NoConnectionView.swift
//  ELG
//
//  Created by Johannes Jakob on 19/09/2017
//  © 2017-2018 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

final class NoConnectionView: UIView {
	// MARK: - Properties
	
	public var textLabel: UILabel = {
		let view = UILabel()
		
		view.numberOfLines = 0
		view.layoutMargins = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
		
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	// MARK: - Initializers
	
	convenience init() {
		self.init(frame: CGRect())
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		initialize()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		initialize()
	}
	
	// MARK: - UIView
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	// MARK: - Public
	
	public func defaultText() -> NSMutableAttributedString {
		let headingParagraphStyle = NSMutableParagraphStyle()
		
		headingParagraphStyle.alignment = .center
		
		let detailsParagraphStyle = NSMutableParagraphStyle()
		
		detailsParagraphStyle.alignment = .center
		detailsParagraphStyle.lineHeightMultiple = 1.2
		
		let heading = NSMutableAttributedString(string: "Keine Verbindung\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.paragraphStyle: headingParagraphStyle])
		let details = NSMutableAttributedString(string: "Bitte überprüfe die Einstellungen. Wische von oben nach unten, um die Seite neu zu laden.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.paragraphStyle: detailsParagraphStyle])
		
		let string = NSMutableAttributedString()
		
		string.append(heading)
		string.append(details)
		
		if #available(iOS 13, *) {
			string.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.secondaryLabel, range: NSRange(location: 0, length: string.length))
		} else {
			string.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: string.length))
		}
		
		return string
	}
	
	// MARK: - Private
	
	private func initialize() {
		addSubview(textLabel)
		
		NSLayoutConstraint.activate([
			NSLayoutConstraint(item: textLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: textLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
			
			NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
		])
	}
}
