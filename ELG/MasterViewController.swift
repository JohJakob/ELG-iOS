//
//  MasterViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 24.06.2016.
//  Copyright © 2016 Elisabeth-Gymnasium Halle. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

  var detailViewController: DetailViewController? = nil
  var objects = [AnyObject]()


  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view, typically from a nib.
    
    if let split = self.splitViewController {
        let controllers = split.viewControllers
        self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
    }
  }

  override func viewWillAppear(animated: Bool) {
    if #available(iOS 8.0, *) {
      self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
    } else {
      // Fallback on earlier versions
    }
    
    super.viewWillAppear(animated)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    // Dispose of any resources that can be recreated.
  }

  /* MARK: - Segues

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showDetail" {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let object = objects[indexPath.row] as! NSDate
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
            controller.detailItem = object
          if #available(iOS 8.0, *) {
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
          } else {
            // Fallback on earlier versions
          }
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
  } */
