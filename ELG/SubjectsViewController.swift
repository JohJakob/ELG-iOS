//
//  SubjectsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 14/07/2016
//  © 2016 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class SubjectsViewController: UITableViewController, UIAlertViewDelegate {
  // Variables + constants
  
  var defaults: NSUserDefaults!
  let subjects = ["Astronomie", "Biologie", "Chemie", "Deutsch", "Englisch", "Ethik", "Französisch", "Freie Stillarbeit", "Geografie", "Geschichte", "Informatik", "Junior-Ingenieur-Akademie", "Kunst", "Latein", "Mathematik", "Medienkunde", "Methodentraining", "Musik", "Physik", "Rechtskunde", "Religion", "Russisch", "Sozialkunde", "Spanisch", "Sport", "Verfügung", "VNU", "Wirtschaftskunde"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
    
    if #available(iOS 8, *) {
      defaults = NSUserDefaults.standardUserDefaults()
    } else {
      defaults = NSUserDefaults.init(suiteName: "group.com.hardykrause.elg")
    }
  }
  
  // Table view functions
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRows: Int
    
    if section == 0 {
      numberOfRows = 1
    } else {
      numberOfRows = subjects.count
    }
    
    return numberOfRows
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("SubjectsTableViewCell", forIndexPath: indexPath)
    
    // Check table view section and set table view cell's text
    
    if indexPath.section == 0 {
      cell.textLabel!.text = "Kein Unterricht"
    } else {
      cell.textLabel!.text = subjects[indexPath.row]
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // Deselect table view cell
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    // Check table view section, show dialog and set user defaults
    
    if indexPath.section == 0 {
      defaults.setValue("Kein Unterricht", forKey: "selectedSubject")
      defaults.synchronize()
      
      // Pop view controller
      
      navigationController?.popViewControllerAnimated(true)
    } else {
      defaults.setValue(subjects[indexPath.row], forKey: "selectedSubject")
      defaults.synchronize()
      
      if #available(iOS 8, *) {
        // Create and show alert
        
        let roomAlert = UIAlertController.init(title: "Raum", message: "Bitte trage den Raum für diese Stunde ein. Lasse das Textfeld frei, um keinen Raum einzutragen.", preferredStyle: .Alert)
        roomAlert.addTextFieldWithConfigurationHandler({(textField) -> Void in
          textField.keyboardType = .NumberPad
        })
        roomAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(action) -> Void in
          if roomAlert.textFields![0].text != nil {
            self.defaults.setValue(roomAlert.textFields![0].text, forKey: "selectedRoom")
            self.defaults.synchronize()
          }
          
          // Pop view controller
          
          self.navigationController?.popViewControllerAnimated(true)
        }))
        presentViewController(roomAlert, animated: true, completion: nil)
      } else {
        // Create and show alert
        
        let roomAlertView = UIAlertView.init(title: "Raum", message: "Bitte trage den Raum für diese Stunde ein.", delegate: self, cancelButtonTitle: "OK")
        roomAlertView.alertViewStyle = .PlainTextInput
        roomAlertView.textFieldAtIndex(0)?.keyboardType = .NumberPad
        roomAlertView.show()
      }
    }
  }
  
  // Alert view function
  
  func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    // Check text field text and set user default
    
    if alertView.textFieldAtIndex(0)!.text != nil {
      defaults.setValue(alertView.textFieldAtIndex(0)?.text, forKey: "selectedRoom")
      defaults.synchronize()
    }
    
    // Pop view controller
    
    navigationController?.popViewControllerAnimated(true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
