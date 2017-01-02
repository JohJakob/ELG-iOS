//
//  DetailViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 05/12/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class DetailViewController: UIViewController {
  // Outlets
  
  @IBOutlet weak private var detailLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set label's text based on iOS version
    
    if #available(iOS 8, *) {
      detailLabel.text = "Tippe links auf einen Menüpunkt oder wähle in Einstellungen → Startseite auswählen eine Startseite aus, die nach dem Start der App hier angezeigt wird."
    } else {
      detailLabel.text = "Wische vom linken Bildschirmrand nach rechts, um das Menü anzuzeigen."
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
