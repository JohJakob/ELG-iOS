//
//  TextFieldTableViewCell.swift
//  ELG
//
//  Created by Johannes Jakob on 14/08/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
  // Outlets
  
  @IBOutlet weak var textField: UITextField!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
