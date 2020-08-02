//
//  SubjectsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 14/07/2016
//  © Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

protocol SubjectsViewControllerDelegate: AnyObject {
	func didDismissViewController(viewController: UIViewController)
}

class SubjectsViewController: UITableViewController, UIAlertViewDelegate {
  // MARK: - Properties
  
	weak var delegate: SubjectsViewControllerDelegate?
  var defaults: UserDefaults!
  let subjects = ["Astronomie", "Biologie", "Chemie", "Deutsch", "Englisch", "Ethik", "Französisch", "Freie Stillarbeit", "Geografie", "Geschichte", "Informatik", "Junior-Ingenieur-Akademie", "Kunst", "Latein", "Mathematik", "Medienkunde", "Methodentraining", "Musik", "Physik", "Rechtskunde", "Religion", "Russisch", "Sozialkunde", "Spanisch", "Sport", "Verfügung", "VNU", "Wirtschaftskunde"]
	
	@IBAction func cancelButtonTap(_ sender: UIBarButtonItem) {
		// Dismiss view
		self.delegate?.didDismissViewController(viewController: self)
		dismiss(animated: true, completion: nil)
	}
	
	// MARK: - UITableViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
		
		defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
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
      
      //_ = self.navigationController?.popViewController(animated: true)
			
			// Dismiss view
			self.delegate?.didDismissViewController(viewController: self)
			dismiss(animated: true, completion: nil)
    } else {
      defaults.setValue(subjects[indexPath.row], forKey: "selectedSubject")
      defaults.synchronize()
      
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
				
				//_ = self.navigationController?.popViewController(animated: true)
				
				// Dismiss view
				self.delegate?.didDismissViewController(viewController: self)
				self.dismiss(animated: true, completion: nil)
			}))
			
			// Present alert
			present(roomAlert, animated: true, completion: nil)
    }
  }
}
