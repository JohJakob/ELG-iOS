//
//  TeacherModeViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 20/11/2016
//  © 2016 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class TeacherModeViewController: UITableViewController, UITextFieldDelegate {
  // Variables
  
  var defaults: NSUserDefaults!
  var teacherMode = Bool()
  var teacherToken = String()
  var teacherModeSwitch = UISwitch()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
    
    if #available(iOS 8, *) {
      defaults = NSUserDefaults.standardUserDefaults()
    } else {
      defaults = NSUserDefaults.init(suiteName: "group.com.hardykrause.elg")
    }
    
    // Register custom table view cell
    
    tableView.registerNib(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
    
    // Initialize switch
    
    initSwitch()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // Retrieve user defaults
    
    retrieveUserDefault()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Set user defaults
    
    setUserDefault()
  }
  
  // Table view functions
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCellWithIdentifier("TeacherModeTableViewCell", forIndexPath: indexPath)
      
      cell.textLabel!.text = "Lehrermodus"
      cell.accessoryView = teacherModeSwitch
      cell.selectionStyle = .None
      
      return cell
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell", forIndexPath: indexPath) as! TextFieldTableViewCell
      
      cell.textField.placeholder = "Kürzel"
      cell.textField.text = teacherToken
      cell.textField.autocapitalizationType = .AllCharacters
      cell.textField.autocorrectionType = .No
      cell.textField.returnKeyType = .Done
      
      cell.textField.delegate = self
      
      return cell
    }
  }
  
  override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return "Bei aktiviertem Lehrermodus werden in den eigenen Vertretungen nur Eintragungen mit dem Kürzel angezeigt."
  }
  
  // Text field functions
  
  func textFieldDidEndEditing(textField: UITextField) {
    // Set variable
    
    teacherToken = textField.text!
    
    // Resign first responder
    
    textField.resignFirstResponder()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    // Resign first responder
    
    textField.resignFirstResponder()
    
    return true
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    // Allow 3 characters in text field
    
    let currentCharacterCount = textField.text?.characters.count ?? 0
    
    if range.length + range.location > currentCharacterCount {
      return false
    }
    
    let newLength = currentCharacterCount + string.characters.count - range.length
    
    return newLength <= 3
  }
  
  // Custom functions
  
  func initSwitch() {
    // Retrieve user default
    
    teacherMode = defaults.boolForKey("teacherMode")
    
    // Initialize switch
    
    teacherModeSwitch = UISwitch.init(frame: CGRectZero)
    
    if teacherMode {
      teacherModeSwitch.setOn(true, animated: false)
    } else {
      teacherModeSwitch.setOn(false, animated: false)
    }
    
    teacherModeSwitch.addTarget(self, action: #selector(TeacherModeViewController.toggleTeacherMode), forControlEvents: .ValueChanged)
    
    teacherModeSwitch.onTintColor = UIColor(red: 0.498, green: 0.09, blue: 0.203, alpha: 1)
  }
  
  func retrieveUserDefault() {
    // Retrieve user default
    
    teacherToken = defaults.stringForKey("teacherToken")!
  }
  
  func setUserDefault() {
    // Set user default
    
    defaults.setBool(teacherMode, forKey: "teacherMode")
    defaults.setObject(teacherToken, forKey: "teacherToken")
    defaults.synchronize()
  }
  
  func toggleTeacherMode() {
    // Set user default
    
    if teacherModeSwitch.on {
      teacherMode = true
    } else {
      teacherMode = false
    }
    
    defaults.setBool(teacherMode, forKey: "teacherMode")
    defaults.synchronize()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
