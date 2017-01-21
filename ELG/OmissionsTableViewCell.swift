//
//  OmissionsTableViewCell.swift
//  ELG
//
//  Created by Johannes Jakob on 12/08/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class OmissionsTableViewCell: UITableViewCell {
  // Outlets
  
  @IBOutlet weak var gradeLabel: UILabel!
  @IBOutlet weak var lessonLabel: UILabel!
  @IBOutlet weak var detailsLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
