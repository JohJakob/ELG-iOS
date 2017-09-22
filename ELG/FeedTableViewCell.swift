//
//  FeedTableViewCell.swift
//  ELG
//
//  Created by Johannes Jakob on 06/09/2017
//  © 2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class FeedTableViewCell: UITableViewCell {
	// MARK: - Properties
	
	public var articleImageView: UIImageView = {
		let view = UIImageView()
		
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	public var articleHeadingLabel: UILabel = {
		let view = UILabel()
		
		view.font = UIFont.boldSystemFont(ofSize: 18)
		view.numberOfLines = 0
		
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	public var articleDateLabel: UILabel = {
		let view = UILabel()
		
		view.textColor = UIColor.lightGray
		view.font = UIFont.systemFont(ofSize: 14)
		view.numberOfLines = 1
		
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	private var visualEffectView: UIVisualEffectView = {
		let view = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
		
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	private var containerView: UIView = {
		let view = UIView()
		
		view.backgroundColor = UIColor.white
		view.clipsToBounds = true
		view.layer.cornerRadius = 10
	
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	private var shadowView: UIView = {
		let view = UIView()
		
		view.backgroundColor = UIColor.white
		view.layer.cornerRadius = 10
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowOffset = CGSize(width: 0, height: 4)
		view.layer.shadowRadius = 10
		view.layer.shadowOpacity = 0.2
		
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
		
		// Configure the view for the selected state
	}
	
	// MARK: - Private
	
	private func initialize() {
		contentView.backgroundColor = UIColor.groupTableViewBackground
		
		containerView.addSubview(articleImageView)
		containerView.addSubview(visualEffectView)
		
		visualEffectView.addSubview(articleHeadingLabel)
		visualEffectView.addSubview(articleDateLabel)
		
		contentView.addSubview(shadowView)
		contentView.addSubview(containerView)
		
		NSLayoutConstraint.activate([
			NSLayoutConstraint(item: shadowView, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 1, constant: -32),
			NSLayoutConstraint(item: shadowView, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1, constant: -32),
			NSLayoutConstraint(item: shadowView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: shadowView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0),
			
			NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 1, constant: -32),
			NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1, constant: -32),
			NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0),
			
			NSLayoutConstraint(item: articleImageView, attribute: .width, relatedBy: .equal, toItem: containerView, attribute: .width, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: articleImageView, attribute: .height, relatedBy: .equal, toItem: containerView, attribute: .height, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: articleImageView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: articleImageView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: articleImageView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: articleImageView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0),
			
			NSLayoutConstraint(item: visualEffectView, attribute: .width, relatedBy: .equal, toItem: containerView, attribute: .width, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: visualEffectView, attribute: .top, relatedBy: .equal, toItem: articleHeadingLabel, attribute: .top, multiplier: 1, constant: -8),
			NSLayoutConstraint(item: visualEffectView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: visualEffectView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: visualEffectView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0),
			
			NSLayoutConstraint(item: articleHeadingLabel, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: -8),
			NSLayoutConstraint(item: articleHeadingLabel, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 8),
			
			NSLayoutConstraint(item: articleDateLabel, attribute: .top, relatedBy: .equal, toItem: articleHeadingLabel, attribute: .bottom, multiplier: 1, constant: 8),
			NSLayoutConstraint(item: articleDateLabel, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: -8),
			NSLayoutConstraint(item: articleDateLabel, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: -8),
			NSLayoutConstraint(item: articleDateLabel, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 8)
		])
	}
}
