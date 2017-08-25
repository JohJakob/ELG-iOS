//
//  PickerTableViewCell.swift
//  ELG
//
//  Created by Johannes Jakob on 26/07/2017
//  © 2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class PickerTableViewCell: UITableViewCell {
	// MARK: - Properties
	
	@IBOutlet var pickerView: UIPickerView!
	
	// MARK: - UITableViewCell
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
}
