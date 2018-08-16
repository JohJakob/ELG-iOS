//
//  SimpleFeedTableViewCell.swift
//  ELG
//
//  Created by Johannes Jakob on 22/09/2017
//  © 2017-2018 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class SimpleFeedTableViewCell: UITableViewCell {
	// MARK: - Properties
	
	public var headingLabel: UILabel = {
		let label = UILabel()
		
		label.font = UIFont.boldSystemFont(ofSize: 20)
		label.numberOfLines = 0
		
		label.translatesAutoresizingMaskIntoConstraints = false
		
		return label
	}()
	
	public var detailsLabel: UILabel = {
		let label = UILabel()
		
		label.textColor = UIColor.lightGray
		label.font = UIFont.boldSystemFont(ofSize: 14)
		label.numberOfLines = 1
		
		label.translatesAutoresizingMaskIntoConstraints = false
		
		return label
	}()
	
	public var containerView: UIView = {
		let view = UIView()
		
		view.backgroundColor = UIColor.white
		
		view.layer.cornerRadius = 10
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowOffset = CGSize(width: 0, height: 2)
		view.layer.shadowRadius = 4
		view.layer.shadowOpacity = 0.1
		
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	// MARK: - Initializers
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		initialize()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		initialize()
	}
	
	// MARK: - UITableViewCell
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
	// MARK: - Private
	
	private func initialize() {
		self.backgroundColor = UIColor.groupTableViewBackground
		contentView.backgroundColor = UIColor.groupTableViewBackground
		
		containerView.addSubview(headingLabel)
		containerView.addSubview(detailsLabel)
		
		contentView.addSubview(containerView)
		
		NSLayoutConstraint.activate([
			NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 8),
			
			NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 16),
			NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: detailsLabel, attribute: .bottom, multiplier: 1, constant: 10),
			
			NSLayoutConstraint(item: headingLabel, attribute: .width, relatedBy: .equal, toItem: containerView, attribute: .width, multiplier: 1, constant: -20),
			NSLayoutConstraint(item: headingLabel, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: headingLabel, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 10),
			NSLayoutConstraint(item: headingLabel, attribute: .bottom, relatedBy: .equal, toItem: detailsLabel, attribute: .top, multiplier: 1, constant: -10),
			
			NSLayoutConstraint(item: detailsLabel, attribute: .width, relatedBy: .equal, toItem: containerView, attribute: .width, multiplier: 1, constant: -20),
			NSLayoutConstraint(item: detailsLabel, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0),
		])
		
		if UI_USER_INTERFACE_IDIOM() == .pad {
			NSLayoutConstraint.activate([
				NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 400)
			])
		} else {
			NSLayoutConstraint.activate([
				NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 1, constant: -32)
			])
		}
	}
}
