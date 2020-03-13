//
//  LoginViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 14/08/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class LoginViewController: UITableViewController, UITextFieldDelegate {
  // MARK: - Properties
  
  @IBOutlet weak var loginButton: UIBarButtonItem!
  
  var defaults: UserDefaults!
  var username = String()
  var password = String()
  var token = String()
  
  @IBAction func loginButtonTap(_ sender: UIBarButtonItem) {
    // Find credentials from 1Password
		
		// TODO: Replace with up-to-date version when onepassword-app-extension supports Swift 3
		
    /* OnePasswordExtension.shared().findLogin(forURLString: "http://www.elg-halle.de", for: self, sender: loginButton, completion: {(loginDictionary: Dictionary<NSObject, AnyObject>?, error: NSError?) in
      if loginDictionary!.count == 0 {
        if Int32(error!.code) != AppExtensionErrorCodeCancelledByUser {
          print("Error invoking 1Password App Extension for finding credentials:" + String(error!))
        }
        
        return
      }
      
      // Set variables
      
      self.username = "\(loginDictionary![AppExtensionUsernameKey]!)"
      self.password = "\(loginDictionary![AppExtensionPasswordKey]!)"
      
      // Reload table view
      
      self.tableView.reloadData()
    }) */
  }
	
	// MARK: - UITableViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
    
		defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
    
    // Register custom table view cell
    
    tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
    
    // Enable login button if password manager is installed
    
    loginButton.isEnabled = OnePasswordExtension.shared().isAppExtensionAvailable()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Retrieve user defaults
    
    retrieveUserDefaults()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Set user defaults
    
    setUserDefaults()
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
    var numberOfRows = Int()
    
    if section == 0 {
      numberOfRows = 2
    } else {
      numberOfRows = 1
    }
    
    return numberOfRows
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
    
    // Set text field's placeholder and text in table view cell
    
    if indexPath.section == 0 {
      if indexPath.row == 0 {
        cell.textField.placeholder = "Benutzername"
        cell.textField.text = username
        cell.textField.tag = 1
      } else {
        cell.textField.placeholder = "Passwort"
        cell.textField.text = password
        cell.textField.isSecureTextEntry = true
        cell.textField.keyboardType = .numbersAndPunctuation
        cell.textField.keyboardAppearance = .dark
        cell.textField.tag = 2
      }
    } else {
      cell.textField.placeholder = "Kürzel"
      cell.textField.text = token
      cell.textField.autocapitalizationType = .words
      cell.textField.tag = 3
    }
    
    // Set text field's delegate
    
    cell.textField.delegate = self
    
    return cell
  }
  
  // Text field functions
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    // Check text field tag and set variables
    
    switch textField.tag {
    case 1:
      username = textField.text!
      break
    case 2:
      password = textField.text!
      break
    case 3:
      token = textField.text!
      break
    default:
      break
    }
    
    // Resign first responder
    
    textField.resignFirstResponder()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // Resign first responder
    
    textField.resignFirstResponder()
    
    return true
  }
  
  // MARK: - Custom
  
  func retrieveUserDefaults() {
    // Retrieve user defaults
    
    username = defaults.string(forKey: "username")!
    password = defaults.string(forKey: "password")!
    token = defaults.string(forKey: "token")!
  }
  
  func setUserDefaults() {
    // Set user defaults
    
    defaults.setValue(username, forKey: "username")
    defaults.setValue(password, forKey: "password")
    defaults.setValue(token, forKey: "token")
    defaults.synchronize()
  }
}
