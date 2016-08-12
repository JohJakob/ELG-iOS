//
//  OmissionsTableViewCell.swift
//  ELG
//
//  Created by Johannes Jakob on 12/08/2016
//  ©2016 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class OmissionsTableViewCell: UITableViewCell {
  // Outlets
  
  @IBOutlet weak private var GradeLabel: UILabel!
  @IBOutlet weak private var LessonLabel: UILabel!
  @IBOutlet weak private var DetailsLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
