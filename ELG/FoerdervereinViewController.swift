//
//  FoerdervereinViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 13/08/2016
//  © Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit
import SWXMLHash
import SafariServices

class FoerdervereinViewController: UITableViewController, UIGestureRecognizerDelegate, SFSafariViewControllerDelegate {
	// MARK: - Properties
	
	@IBOutlet var segmentedControl: UISegmentedControl!
  
  var defaults: UserDefaults!
	var articles = [[String: String]]()
	var currentArticle = [String: String]()
	let weekdays = ["Mon": "Montag", "Tue": "Dienstag", "Wed": "Mittwoch", "Thu": "Donnerstag", "Fri": "Freitag", "Sat": "Samstag", "Sun": "Sonntag"]
	let months = ["Jan": "Januar", "Feb": "Februar", "Mar": "März", "Apr": "April", "May": "Mai", "Jun": "Juni", "Jul": "Juli", "Aug": "August", "Sep": "September", "Oct": "Oktober", "Nov": "November", "Dec": "Dezember"]
  let articleViewController = FoerdervereinArticleViewController()
	
	// MARK: - UITableViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
		
		initialize()
  }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		showArticles()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
  // MARK: - UITableView
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    var numberOfSections = Int()
		
    let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
    
    if reachabilityStatus != NotReachable {
      numberOfSections = 1
    } else {
      numberOfSections = 0
    }
    
    return numberOfSections
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return articles.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleFeedTableViewCell", for: indexPath) as? SimpleFeedTableViewCell
		
		cell?.headingLabel.text = articles[indexPath.row]["heading"]
		cell?.detailsLabel.text = articles[indexPath.row]["date"]
		
		cell?.selectionStyle = .none
		
		return cell!
  }
	
	override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		highlightCell(indexPath: indexPath)
	}
	
	override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		unhighlightCell(indexPath: indexPath)
	}
	
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if #available(iOS 9, *) {
			// Initialize SFSafariViewController and later to open selected article (iOS 9+)
			
			let safariView = SFSafariViewController(url: URL(string: articles[indexPath.row]["link"] ?? "https://svelg.wordpress.com")!)
			
			safariView.delegate = self
			
			self.present(safariView, animated: true, completion: nil)
		} else {
			// Save selected article metadata to UserDefaults and navigate to FoerdervereinArticleViewController (iOS 8)
			
			defaults.setValue(articles[indexPath.row]["heading"], forKey: "selectedArticleTitle")
			defaults.setValue(articles[indexPath.row]["link"], forKey: "selectedArticleLink")
			defaults.synchronize()
			
			navigationController?.show(articleViewController, sender: self)
		}
  }
	
	// MARK: - Private
	
	private func initialize() {
		defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
		
		segmentedControl.addTarget(self, action: #selector(changeView), for: .valueChanged)
		
		initializeTableView()
		
		let articlesRefreshControl = UIRefreshControl.init()
		
		articlesRefreshControl.addTarget(self, action: #selector(showArticles), for: .valueChanged)
		
		refreshControl = articlesRefreshControl
	}
	
	@objc private func changeView() {
		var navigationStack = navigationController?.viewControllers
		var localNavigationStack = navigationStack
		var newsViewController = UIViewController()
		
		if #available(iOS 11, *) {
			newsViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewsViewController")
		} else {
			newsViewController = UIStoryboard(name: "MainLegacy", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewsViewController")
		}
		
		navigationStack?.remove(at: (localNavigationStack!.count) - 1)
		
		localNavigationStack = navigationStack
		
		navigationStack?.insert(newsViewController, at: (localNavigationStack?.count)!)
		navigationController?.setViewControllers(navigationStack!, animated: false)
	}
	
	private func initializeTableView() {
		tableView.register(SimpleFeedTableViewCell.self, forCellReuseIdentifier: "SimpleFeedTableViewCell")
		
		tableView.estimatedRowHeight = 97
		tableView.rowHeight = UITableView.automaticDimension
		
		tableView.backgroundColor = UIColor.groupTableViewBackground
		tableView.separatorColor = UIColor.clear
		tableView.separatorStyle = .none
	}
	
	@objc private func showArticles() {
		let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
		
		if reachabilityStatus != NotReachable {
			download(completion: { (items) in
				self.articles = items
				self.tableView.reloadData()
			})
		} else {
			let noConnectionView = NoConnectionView()
			
			noConnectionView.textLabel.attributedText = noConnectionView.defaultText()
			
			tableView.backgroundColor = UIColor.groupTableViewBackground
			tableView.separatorStyle = .none
			tableView.backgroundView = noConnectionView
		}
		
		refreshControl?.endRefreshing()
	}
	
	private func download(completion: @escaping (_ articles: [[String: String]]) -> ()) {
		let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
		
		if reachabilityStatus != NotReachable {
			var request = URLRequest(url: URL(string: "https://svelg.wordpress.com/feed")!)
			
			request.httpMethod = "GET"
			
			URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
				DispatchQueue.main.async {
					if let error = error {
						let errorAlertController = UIAlertController(title: "Fehler", message: "Es ist folgender Fehler aufgetreten: \(error.localizedDescription)", preferredStyle: .alert)
						
						errorAlertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
							self.dismiss(animated: true, completion: nil)
						}))
						
						self.present(errorAlertController, animated: true, completion: nil)
						
						return
					}
					
					guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
						let responseErrorAlertController = UIAlertController(title: "Server-Fehler", message: "Die Artikel konnten nicht geladen werden.", preferredStyle: .alert)
						
						responseErrorAlertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
							self.dismiss(animated: true, completion: nil)
						}))
						
						self.present(responseErrorAlertController, animated: true, completion: nil)
						
						return
					}
					
					let xml = SWXMLHash.parse(data!)
					var items = [[String: String]]()
					
					for element in xml["rss"]["channel"]["item"].all {
						var currentItem = [String: String]()
						
						currentItem["heading"] = element["title"].element?.text
						currentItem["date"] = self.transformDate(dateString: (element["pubDate"].element?.text)!)
						currentItem["link"] = element["link"].element?.text
						
						items.append(currentItem)
					}
					
					completion(items)
				}
			}).resume()
		}
	}
	
	private func transformDate(dateString: String) -> String {
		var string = dateString
		
		string.removeSubrange(string.startIndex...string.index(string.startIndex, offsetBy: 5))
		string.removeSubrange(string.index(string.endIndex, offsetBy: -6)..<string.endIndex)
		
		let dateFormatter = DateFormatter()
		
		dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"
		
		let date = dateFormatter.date(from: string)
		
		dateFormatter.dateFormat = "EEEE, dd. MMMM yyyy"
		dateFormatter.locale = Locale.init(identifier: "de_DE")
		
		return dateFormatter.string(from: date!).uppercased()
	}
	
	private func highlightCell(indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! SimpleFeedTableViewCell
		
		UIView.animate(withDuration: 0.2, animations: {
			cell.containerView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
		})
	}
	
	private func unhighlightCell(indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! SimpleFeedTableViewCell
		
		UIView.animate(withDuration: 0.2, animations: {
			cell.containerView.transform = CGAffineTransform(scaleX: 1, y: 1)
		})
	}
}
