//
//  MasterViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 24/06/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class MasterViewController: UITableViewController, UISplitViewControllerDelegate {
  // Variables + constants
  
  // var startViewController: StartViewController? = nil
  var defaults: UserDefaults!
  var startView = Int()
  let onboardingViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OnboardingNavigationController")
  let startViewControllers = ["NewsNavigationController", "ScheduleNavigationController", "OmissionsNavigationController", "FoerdervereinNavigationController"]
  let lessonsViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LessonsTableViewController")
  let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
  
  override func viewDidLoad() {
    super.viewDidLoad()
		
		// Set split view's delegate
		
		splitViewController?.delegate = self
		
		// Set split view's preferred display mode
		
		splitViewController?.preferredDisplayMode = .allVisible
    
    // Initialize user defaults
    
    defaults = UserDefaults.init(suiteName: "group.com.hardykrause.elg")
		
		// Set up app
		
		setUp()
		
		// Show start view
		
		showStartView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // Check first launch
    
		if (defaults.bool(forKey: "launched\(String(describing: version))") != true) {
      // Show introduction
      
      showIntroduction()
    }
		
		// Open page via URL query
		
		openPage()
    
    // Remove temporary user defaults
    
    removeUserDefaults()
  }
  
  // Table view functions
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Deselect table view cell
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
	
	// Split view functions
	
	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		return true
	}
  
  // Custom functions
  
  func setUp() {
    // Set back indicator image
    
    navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Back")
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Back")
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    // Set title view
    
    navigationItem.titleView = UIImageView.init(image: UIImage(named: "Schulkreuz"))
    
    // Set empty teacher token in user defaults
    
    if defaults.string(forKey: "teacherToken") == nil {
      defaults.set("", forKey: "teacherToken")
    }
    
    // Synchronize user defaults
    
    defaults.synchronize()
  }
  
  func showIntroduction() {
    // Change selected grade integer due to addition of grade 7e
		
		if defaults.integer(forKey: "selectedGrade") > 13 {
			defaults.set(defaults.integer(forKey: "selectedGrade") + 1, forKey: "selectedGrade")
			
			defaults.synchronize()
		}
    
    // Set up app
    
    setUp()
    
    // Show release notes
    
    /* navigationController?.showViewController(aboutWebViewController, sender: self) */
    
    present(onboardingViewController, animated: true, completion: nil)
  }
  
  func showStartView() {
		// Check first launch
		
		if (defaults.bool(forKey: "launched\(String(describing: version))") == true) {
			// Get user default
			
			startView = defaults.integer(forKey: "startView")
			
			// Show start view based on user setting
			
			if startView != 0 {
				if startView == 2 {
					// Get current weekday
					
					let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)
					let dateComponents = (gregorianCalendar! as NSCalendar).components(.weekday, from: Date())
					
					if dateComponents.weekday != 1 && dateComponents.weekday != 7 {
						// Set user default
						
						defaults.set(dateComponents.weekday! - 2, forKey: "selectedDay")
						defaults.synchronize()
						
						// Show start view
						
						showDetailViewController(lessonsViewController, sender: self)
					} else {
						// Set user default
						
						defaults.set(0, forKey: "selectedDay")
						defaults.synchronize()
						
						// Show start view
						
						showDetailViewController(lessonsViewController, sender: self)
					}
				} else {
					// Show start view
					
					showDetailViewController(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: startViewControllers[startView - 1]), sender: self)
				}
			}
		}
  }
	
	func openPage() {
		// Check user default
		
		if defaults.string(forKey: "openPage") == "omissions" {
			// Remove user default
			
			defaults.removeObject(forKey: "openPage")
			
			defaults.synchronize()
			
			// Show new view
			
			showDetailViewController(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: startViewControllers[2]), sender: self)
		}
	}
  
  func removeUserDefaults() {
    // Remove temporary user defaults
    
    defaults.removeObject(forKey: "selectedSubject")
    defaults.removeObject(forKey: "selectedRoom")
    defaults.removeObject(forKey: "selectedAboutWebView")
    defaults.synchronize()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
