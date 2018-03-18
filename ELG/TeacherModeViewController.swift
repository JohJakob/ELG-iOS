//
//  TeacherModeViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 20/11/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class TeacherModeViewController: UITableViewController, UITextFieldDelegate {
  // MARK: - Properties
  
  var defaults: UserDefaults!
  var teacherMode = Bool()
  var teacherToken = String()
  var teacherModeSwitch = UISwitch()
	
	// MARK: - UITableViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
		
		defaults = UserDefaults.init(suiteName: "group.com.hardykrause.elg")
    
    // Register custom table view cell
    
    tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
    
    // Initialize switch
    
    initSwitch()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Retrieve user defaults
    
    retrieveUserDefault()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Set user defaults
    
    setUserDefault()
  }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
  // MARK: - UITableView
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Check index path and set table view cell's properties
    
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherModeTableViewCell", for: indexPath)
      
      cell.textLabel!.text = "Lehrermodus"
      cell.accessoryView = teacherModeSwitch
      cell.selectionStyle = .none
      
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
      
      cell.textField.placeholder = "Kürzel"
      cell.textField.text = teacherToken
      cell.textField.autocapitalizationType = .allCharacters
      cell.textField.autocorrectionType = .no
      cell.textField.returnKeyType = .done
      
      cell.textField.delegate = self
      
      return cell
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return "Bei aktiviertem Lehrermodus werden in den eigenen Vertretungen nur Eintragungen mit dem Kürzel angezeigt."
  }
  
  // MARK: - UITextField
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    // Set variable
    
    teacherToken = textField.text!
    
    // Resign first responder
    
    textField.resignFirstResponder()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // Resign first responder
    
    textField.resignFirstResponder()
    
    return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    // Allow 3 characters in text field
    
    let currentCharacterCount = textField.text?.characters.count ?? 0
    
    if range.length + range.location > currentCharacterCount {
      return false
    }
    
    let newLength = currentCharacterCount + string.characters.count - range.length
    
    return newLength <= 3
  }
  
  // MARK: - Custom
  
  func initSwitch() {
    // Retrieve user default
    
    teacherMode = defaults.bool(forKey: "teacherMode")
    
    // Initialize switch
    
    teacherModeSwitch = UISwitch.init(frame: CGRect.zero)
    
    if teacherMode {
      teacherModeSwitch.setOn(true, animated: false)
    } else {
      teacherModeSwitch.setOn(false, animated: false)
    }
    
    teacherModeSwitch.addTarget(self, action: #selector(TeacherModeViewController.toggleTeacherMode), for: .valueChanged)
    
    teacherModeSwitch.onTintColor = UIColor(red: 0.498, green: 0.09, blue: 0.203, alpha: 1)
  }
  
  func retrieveUserDefault() {
    // Retrieve user default
    
    teacherToken = defaults.string(forKey: "teacherToken")!
  }
  
  func setUserDefault() {
    // Set user default
    
    defaults.set(teacherMode, forKey: "teacherMode")
    defaults.set(teacherToken, forKey: "teacherToken")
    defaults.synchronize()
  }
  
  @objc func toggleTeacherMode() {
    // Set user default
    
    if teacherModeSwitch.isOn {
      teacherMode = true
    } else {
      teacherMode = false
    }
    
    defaults.set(teacherMode, forKey: "teacherMode")
    defaults.synchronize()
  }
}
