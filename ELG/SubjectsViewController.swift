//
//  SubjectsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 14/07/2016
//  © 2016-2018 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class SubjectsViewController: UITableViewController, UIAlertViewDelegate {
  // MARK: - Properties
  
  var defaults: UserDefaults!
  let subjects = ["Astronomie", "Biologie", "Chemie", "Deutsch", "Englisch", "Ethik", "Französisch", "Freie Stillarbeit", "Geografie", "Geschichte", "Informatik", "Junior-Ingenieur-Akademie", "Kunst", "Latein", "Mathematik", "Medienkunde", "Methodentraining", "Musik", "Physik", "Rechtskunde", "Religion", "Russisch", "Sozialkunde", "Spanisch", "Sport", "Verfügung", "VNU", "Wirtschaftskunde"]
	
	// MARK: - UITableViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
		
		defaults = UserDefaults.init(suiteName: "group.com.hardykrause.elg")
  }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
  // MARK: - UITableView
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var numberOfRows: Int
    
    if section == 0 {
      numberOfRows = 1
    } else {
      numberOfRows = subjects.count
    }
    
    return numberOfRows
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectsTableViewCell", for: indexPath)
    
    // Check table view section and set table view cell's text
    
    if indexPath.section == 0 {
      cell.textLabel!.text = "Kein Unterricht"
    } else {
      cell.textLabel!.text = subjects[indexPath.row]
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Deselect table view cell
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    // Check table view section, show dialog and set user defaults
    
    if indexPath.section == 0 {
      defaults.setValue("Kein Unterricht", forKey: "selectedSubject")
      defaults.synchronize()
      
      // Pop view
      
      _ = self.navigationController?.popViewController(animated: true)
    } else {
      defaults.setValue(subjects[indexPath.row], forKey: "selectedSubject")
      defaults.synchronize()
      
      if #available(iOS 8, *) {
        // Create and show alert
        
        let roomAlert = UIAlertController.init(title: "Raum", message: "Bitte trage den Raum für diese Stunde ein. Lasse das Textfeld frei, um keinen Raum einzutragen.", preferredStyle: .alert)
        roomAlert.addTextField(configurationHandler: {(textField) -> Void in
          textField.keyboardType = .numberPad
        })
        roomAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action) -> Void in
          if roomAlert.textFields![0].text != nil {
            self.defaults.setValue(roomAlert.textFields![0].text, forKey: "selectedRoom")
            self.defaults.synchronize()
          }
          
          // Pop view
          
          _ = self.navigationController?.popViewController(animated: true)
        }))
        present(roomAlert, animated: true, completion: nil)
      } else {
        // Create and show alert
        
        let roomAlertView = UIAlertView.init(title: "Raum", message: "Bitte trage den Raum für diese Stunde ein.", delegate: self, cancelButtonTitle: "OK")
        roomAlertView.alertViewStyle = .plainTextInput
        roomAlertView.textField(at: 0)?.keyboardType = .numberPad
        roomAlertView.show()
      }
    }
  }
  
  // MARK: - UIAlertView
  
  func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
    // Check text field text and set user default
    
    if alertView.textField(at: 0)!.text != nil {
      defaults.setValue(alertView.textField(at: 0)?.text, forKey: "selectedRoom")
      defaults.synchronize()
    }
    
    // Pop view
    
    navigationController?.popViewController(animated: true)
  }
}
