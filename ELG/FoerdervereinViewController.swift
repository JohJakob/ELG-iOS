//
//  FoerdervereinViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 13/08/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class FoerdervereinViewController: UITableViewController {
	// MARK: - Properties
	
	@IBOutlet var segmentedControl: UISegmentedControl!
  
  var defaults: UserDefaults!
  var items = [[String: String]]()
  var item = Dictionary<String, String>()
  var itemTitle = String()
  var itemDescription = String()
  var itemLink = String()
  let articleViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FoerdervereinArticleViewController")
	
	// MARK: - UITableViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
		
		segmentedControl.addTarget(self, action: #selector(FoerdervereinViewController.changeView), for: .valueChanged)
    
    // Initialize user defaults
		
		defaults = UserDefaults.init(suiteName: "group.com.hardykrause.elg")
		
		// Set back indicator image
		
		navigationController?.navigationBar.backIndicatorImage = UIImage(named: "BackIndicator")
		navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "BackIndicator")
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		
    // Set up refresh control
    
    let articlesRefreshControl = UIRefreshControl.init()
    
    articlesRefreshControl.addTarget(self, action: #selector(FoerdervereinViewController.refreshTableView), for: .valueChanged)
    
    refreshControl = articlesRefreshControl
    
    // Check internet reachability
    
    let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      initParser()
    } else {
      // Show alert
      
      let noConnectionAlert = UIAlertView(title: "Keine Internetverbindung", message: "Es besteht keine Verbindung zum Internet. Bitte überprüfe Deine Einstellungen.", delegate: self, cancelButtonTitle: "OK")
      noConnectionAlert.show()
      
      // Display label instead of table view
      
      let noConnectionLabel = UILabel.init()
      noConnectionLabel.text = "Keine Internetverbindung"
      noConnectionLabel.textColor = UIColor.lightGray
      noConnectionLabel.font = UIFont.systemFont(ofSize: 16)
      noConnectionLabel.textAlignment = .center
      
      // Change table view appearance
      
      tableView.backgroundColor = UIColor.groupTableViewBackground
      tableView.separatorStyle = .none
      tableView.backgroundView = noConnectionLabel
    }
  }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
  // MARK: - UITableView
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    var numberOfSections = Int()
    
    // Check internet reachability
    
    let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      numberOfSections = 1
    } else {
      numberOfSections = 0
    }
    
    return numberOfSections
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FoerdervereinTableViewCell", for: indexPath)
    
    // Set table view cell's text
    
    cell.textLabel!.text = items[indexPath.row]["title"]
    cell.detailTextLabel!.text = items[indexPath.row]["description"]
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Deselect table view cell
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    // Save user defaults
    
    defaults.setValue(items[indexPath.row]["title"], forKey: "selectedArticleTitle")
    defaults.setValue(items[indexPath.row]["link"], forKey: "selectedArticleLink")
    defaults.synchronize()
    
    // Show new view
		
		navigationController?.show(articleViewController, sender: self)
  }
  
  // MARK: - Custom
	
	func changeView() {
		var navigationStack = navigationController?.viewControllers
		let newsViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewsViewController")
		
		navigationStack?.remove(at: (navigationStack!.count) - 1)
		navigationStack?.insert(newsViewController, at: (navigationStack?.count)!)
		navigationController?.setViewControllers(navigationStack!, animated: false)
	}
  
  func initParser() {
    // Create task
    
		let session = URLSession.shared
    var request = URLRequest(url: URL(string: "https://svelg.wordpress.com/feed")!)
    var error: NSError?
    
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: {
      (data, response, error) in
      
      if data == nil {
        // Error
        
        return
      }
      
      // Parse feed
      
      func parse() {
        // Create parser
        
        let xml = SWXMLHash.parse(data!)
        
        // Parse feed
        
        for feedElement in xml["rss"]["channel"]["item"].all {
          self.item["title"] = feedElement["title"].element?.text
          self.item["description"] = feedElement["description"].element?.text
          self.item["link"] = feedElement["link"].element?.text
          
          self.items.append(self.item)
        }
        
        // Reload table view
        
        self.tableView.reloadData()
        
        // Reset table view appearance
        
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorStyle = .singleLine
      }
      
      // Run task asynchronously
      
      DispatchQueue.main.async(execute: parse)
    }) 
    
    task.resume()
  }
  
  func refreshTableView() {
    let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      initParser()
    } else {
      // Reload table view
      
      tableView.reloadData()
      
      // Show alert
      
      let noConnectionAlert = UIAlertView(title: "Keine Internetverbindung", message: "Es besteht keine Verbindung zum Internet. Bitte überprüfe Deine Einstellungen.", delegate: self, cancelButtonTitle: "OK")
      noConnectionAlert.show()
      
      // Display label instead of table view
      
      let noConnectionLabel = UILabel.init()
      noConnectionLabel.text = "Keine Internetverbindung"
      noConnectionLabel.textColor = UIColor.lightGray
      noConnectionLabel.font = UIFont.systemFont(ofSize: 16)
      noConnectionLabel.textAlignment = .center
      
      tableView.separatorStyle = .none
      tableView.backgroundView = noConnectionLabel
    }
    
    refreshControl?.endRefreshing()
  }
}
