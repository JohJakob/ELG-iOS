//
//  FoerdervereinTableViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 13/08/2016
//  ©2016 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class FoerdervereinTableViewController: UITableViewController {
  // Variables
  
  var defaults: NSUserDefaults!
  var items = [[String: String]]()
  var item = Dictionary<String, String>()
  var itemTitle = String()
  var itemDescription = String()
  var itemLink = String()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize user defaults
    
    if #available(iOS 8, *) {
      defaults = NSUserDefaults.standardUserDefaults()
    } else {
      defaults = NSUserDefaults.init(suiteName: "group.com.hardykrause.elg")
    }
    
    // Set up refresh control
    
    let articlesRefreshControl = UIRefreshControl.init()
    
    articlesRefreshControl.addTarget(self, action: #selector(FoerdervereinTableViewController.refreshTableView), forControlEvents: .ValueChanged)
    
    refreshControl = articlesRefreshControl
    
    // Check internet reachability
    
    let reachabilityStatus: NetworkStatus = Reachability.reachabilityForInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      initParser()
    } else {
      // Show alert
      
      let noConnectionAlert = UIAlertView(title: "Keine Internetverbindung", message: "Es besteht keine Verbindung zum Internet. Bitte überprüfe Deine Einstellungen.", delegate: self, cancelButtonTitle: "OK")
      noConnectionAlert.show()
      
      // Display label instead of table view
      
      let noConnectionLabel = UILabel.init()
      noConnectionLabel.text = "Keine Internetverbindung"
      noConnectionLabel.textColor = UIColor.lightGrayColor()
      noConnectionLabel.font = UIFont.systemFontOfSize(16)
      noConnectionLabel.textAlignment = .Center
      
      // Change table view appearance
      
      tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
      tableView.separatorStyle = .None
      tableView.backgroundView = noConnectionLabel
    }
  }
  
  // Table view functions
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    var numberOfSections = Int()
    
    // Check internet reachability
    
    let reachabilityStatus: NetworkStatus = Reachability.reachabilityForInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      numberOfSections = 1
    } else {
      numberOfSections = 0
    }
    
    return numberOfSections
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("FoerdervereinTableViewCell", forIndexPath: indexPath)
    
    // Set cell's text
    
    cell.textLabel!.text = items[indexPath.row]["title"]
    cell.detailTextLabel!.text = items[indexPath.row]["description"]
    
    return cell
  }
  
  // Custom functions
  
  func initParser() {
    // Create task
    
    let session = NSURLSession.sharedSession()
    let request = NSMutableURLRequest(URL: NSURL(string: "https://svelg.wordpress.com/feed")!)
    var error: NSError?
    
    request.HTTPMethod = "GET"
    
    let task = session.dataTaskWithRequest(request) {
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
        
        for feedElement in xml["rss"]["channel"]["item"] {
          self.item["title"] = feedElement["title"].element?.text
          self.item["description"] = feedElement["description"].element?.text
          self.item["link"] = feedElement["link"].element?.text
          
          self.items.append(self.item)
        }
        
        // Reload table view
        
        self.tableView.reloadData()
        
        // Reset table view appearance
        
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.separatorStyle = .SingleLine
      }
      
      // Run task asynchronously
      
      dispatch_async(dispatch_get_main_queue(), parse)
    }
    
    task.resume()
  }
  
  func refreshTableView() {
    let reachabilityStatus: NetworkStatus = Reachability.reachabilityForInternetConnection().currentReachabilityStatus()
    
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
      noConnectionLabel.textColor = UIColor.lightGrayColor()
      noConnectionLabel.font = UIFont.systemFontOfSize(16)
      noConnectionLabel.textAlignment = .Center
      
      tableView.separatorStyle = .None
      tableView.backgroundView = noConnectionLabel
    }
    
    refreshControl?.endRefreshing()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    print("Memory Warning")
  }
}
