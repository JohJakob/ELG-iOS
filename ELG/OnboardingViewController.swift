//
//  OnboardingViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 01/01/2017
//  © 2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class IntroductionViewController: UITableViewController {
  // Variables + constants
  
  var defaults: NSUserDefaults!
  let settingsViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("SettingsTableViewController")
  let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
  
  // Actions
  
  @IBAction func doneButtonTap(sender: UIBarButtonItem) {
    // Initialize user defaults
    
    if #available(iOS 8, *) {
      defaults = NSUserDefaults.standardUserDefaults()
    } else {
      defaults = NSUserDefaults.init(suiteName: "group.com.hardykrause.elg")
    }
    
    // Set user default
    
    defaults.setBool(true, forKey: "launched\(version)")
    
    defaults.synchronize()
    
    // Dismiss view
    
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set navigation bar title
    
    navigationItem.title = "ELG " + version!
  }
  
  // Table view functions
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("OnboardingTableViewCell", forIndexPath: indexPath)
    
    cell.textLabel!.text = "Einstellungen"
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // Navigate to new view
    
    if #available(iOS 8, *) {
      navigationController?.showViewController(settingsViewController, sender: self)
    } else {
      navigationController?.pushViewController(settingsViewController, animated: true)
    }
  }
  
  override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return "Aufgrund der Neuentwicklung der App und der Veränderung einiger Vorgänge mussten sämtliche gesicherten Daten entfernt werden. In den Einstellungen kannst Du sie erneut eingeben. Ich hoffe auf Dein Verständnis."
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
