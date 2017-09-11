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
	
	
	
	// MARK: - Initializers
	
	override convenience init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		self.init(style: style, reuseIdentifier: reuseIdentifier)
		
		selfInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		selfInit()
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	// MARK: - Private
	
	private func selfInit() {
		
	}
}
