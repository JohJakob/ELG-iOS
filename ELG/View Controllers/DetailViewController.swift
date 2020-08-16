//
//  DetailViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 05/12/2016
//  © Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class DetailViewController: UIViewController {
  // Outlets
  
  @IBOutlet weak fileprivate var detailLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set label's text based on iOS version
		
		detailLabel.text = "Tippe links auf einen Menüpunkt oder wähle in Einstellungen → Startseite auswählen eine Startseite aus, die nach dem Start der App hier angezeigt wird."
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
