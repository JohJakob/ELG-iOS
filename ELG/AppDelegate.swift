//
//  AppDelegate.swift
//  ELG
//
//  Created by Johannes Jakob on 24/06/2016
//  © 2016-2018 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
	
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		// Load storyboard according to the device’s iOS version
		
		var storyboard = UIStoryboard()
		
		if #available(iOS 11, *) {
			storyboard = UIStoryboard.init(name: "Main", bundle: nil)
		} else {
			storyboard = UIStoryboard.init(name: "MainLegacy", bundle: nil)
		}
		
		self.window?.rootViewController = storyboard.instantiateInitialViewController()
		
    let defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
		let startView = defaults?.integer(forKey: "startView")
		
		if let tabBarController = window!.rootViewController as? UITabBarController {
			if startView == 1 {
				let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)
				let dateComponents = (gregorianCalendar! as NSCalendar).components(.weekday, from: Date())
				
				if dateComponents.weekday != 1 && dateComponents.weekday != 7 {
					defaults?.set(dateComponents.weekday! - 2, forKey: "selectedDay")
				} else {
					defaults?.set(0, forKey: "selectedDay")
				}
				
				defaults?.set(false, forKey: "didShowSchedule")
				
				defaults?.synchronize()
				
				tabBarController.selectedIndex = 1
			} else if startView == 2 {
				tabBarController.selectedIndex = 2
			}
			
			tabBarController.tabBar.tintColor = UIColor(red: 0.498, green: 0.09, blue: 0.204, alpha: 1)
		}
		
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
	
	func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
		let defaults = UserDefaults.init(suiteName: "group.com.hardykrause.elg")
		
		if let tabBarController = window!.rootViewController as? UITabBarController {
			if url.query == "page=lessons" {
				tabBarController.selectedIndex = 1
			} else if url.query == "page=omissions" {
				tabBarController.selectedIndex = 2
				
				defaults?.removeObject(forKey: "selectedDay")
			} else if url.query == "page=settings" {
				tabBarController.selectedIndex = 3
				
				defaults?.removeObject(forKey: "selectedDay")
			}
		}
		
		return true
	}
}
