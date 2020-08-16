//
//  TextFieldTableViewCell.swift
//  ELG
//
//  Created by Johannes Jakob on 14/08/2016
//  © Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
  // MARK: - Properties
  
  @IBOutlet weak var textField: UITextField!
	
	// MARK: - UITableViewCell
	
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
