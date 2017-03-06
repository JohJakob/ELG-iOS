//
//  OnboardingViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 01/01/2017
//  © 2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class OnboardingViewController: UITableViewController {
  // Variables + constants
  
  var defaults: UserDefaults!
  let settingsViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingsTableViewController")
  let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
  
  // Actions
  
  @IBAction func doneButtonTap(_ sender: UIBarButtonItem) {
    // Initialize user defaults
		
		defaults = UserDefaults.init(suiteName: "group.com.hardykrause.elg")
    
    // Set user default
    
    defaults.set(true, forKey: "launched\(version)")
    
    defaults.synchronize()
    
    // Dismiss view
    
    dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set navigation bar title
    
    navigationItem.title = "ELG " + version!
		
		// Set back indicator image
		
		navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Back")
		navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Back")
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
	
  // Table view functions
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OnboardingTableViewCell", for: indexPath)
    
    cell.textLabel!.text = "Einstellungen"
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Show new view
		
		navigationController?.show(settingsViewController, sender: self)
  }
  
  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return "Aufgrund der Neuentwicklung der App und der Veränderung einiger Vorgänge mussten sämtliche gesicherten Daten entfernt werden. In den Einstellungen kannst Du sie erneut eingeben. Ich hoffe auf Dein Verständnis."
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}