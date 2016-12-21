//
//  TodayViewController.swift
//  OmissionsWidget
//
//  Created by Johannes Jakob on 21/12/2016
//  © 2016 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // Widget functions
  
  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    
    completionHandler(NCUpdateResult.NewData)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
