//
//  TextFieldTableViewCell.swift
//  ELG
//
//  Created by Johannes Jakob on 14.08.2016.
//  Copyright © 2016 Elisabeth-Gymnasium Halle. All rights reserved.
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
