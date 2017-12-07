//
//  FoerdervereinViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 13/08/2016
//  © 2016-2017 Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit

class FoerdervereinViewController: UITableViewController, UIGestureRecognizerDelegate, XMLParserDelegate {
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
    defaults.setValue(articles[indexPath.row]["heading"], forKey: "selectedArticleTitle")
    defaults.setValue(articles[indexPath.row]["link"], forKey: "selectedArticleLink")
    defaults.synchronize()
		
		navigationController?.show(articleViewController, sender: self)
  }
	
	// MARK: - Private
	
	private func initialize() {
		defaults = UserDefaults.init(suiteName: "group.com.hardykrause.elg")
		
		segmentedControl.addTarget(self, action: #selector(changeView), for: .valueChanged)
		
		initializeTableView()
		
		let articlesRefreshControl = UIRefreshControl.init()
		
		articlesRefreshControl.addTarget(self, action: #selector(showArticles), for: .valueChanged)
		
		refreshControl = articlesRefreshControl
	}
	
	@objc private func changeView() {
		var navigationStack = navigationController?.viewControllers
		let newsViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewsViewController")
		
		navigationStack?.remove(at: (navigationStack!.count) - 1)
		navigationStack?.insert(newsViewController, at: (navigationStack?.count)!)
		navigationController?.setViewControllers(navigationStack!, animated: false)
	}
	
	private func initializeTableView() {
		tableView.register(SimpleFeedTableViewCell.self, forCellReuseIdentifier: "SimpleFeedTableViewCell")
		
		tableView.estimatedRowHeight = 97
		tableView.rowHeight = UITableViewAutomaticDimension
		
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
			let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognized(tapRecognizer:)))
			
			noConnectionView.textLabel.attributedText = noConnectionView.defaultText()
			noConnectionView.addGestureRecognizer(tapRecognizer)
			
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
						currentItem["date"] = self.transformDate(string: (element["pubDate"].element?.text)!)
						currentItem["link"] = element["link"].element?.text
						
						items.append(currentItem)
					}
					
					completion(items)
				}
			}).resume()
		}
	}
	
	private func transformDate(string: String) -> String {
		let dateFormatter = DateFormatter()
		
		dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss +zzzz"
		
		let date = dateFormatter.date(from: string)
		
		dateFormatter.dateFormat = "EEEE, dd. MMMM yyyy"
		dateFormatter.locale = Locale.init(identifier: "de_DE")
		
		return dateFormatter.string(from: date!).uppercased()
	}
	
	@objc private func tapRecognized(tapRecognizer: UITapGestureRecognizer) {
		showArticles()
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
