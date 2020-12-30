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
	var feedPage: Int = 1
	var articles = [[String: String]]()
	var currentArticle = [String: String]()
	let weekdays = ["Mon": "Montag", "Tue": "Dienstag", "Wed": "Mittwoch", "Thu": "Donnerstag", "Fri": "Freitag", "Sat": "Samstag", "Sun": "Sonntag"]
	let months = ["Jan": "Januar", "Feb": "Februar", "Mar": "März", "Apr": "April", "May": "Mai", "Jun": "Juni", "Jul": "Juli", "Aug": "August", "Sep": "September", "Oct": "Oktober", "Nov": "November", "Dec": "Dezember"]
	fileprivate var loadMoreActivityIndicator: LoadMoreActivityIndicator!
	
	// MARK: - UITableViewController
	
  override func viewDidLoad() {
    super.viewDidLoad()
		
		initialize()
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
		let safariView = SFSafariViewController(url: URL(string: articles[indexPath.row]["link"] ?? "https://svelg.wordpress.com")!)
		
		safariView.delegate = self
		
		self.present(safariView, animated: true, completion: nil)
  }
	
	// MARK: - Private
	
	///
	/// Set up the view
	///
	private func initialize() {
		// Initialize user defaults
		defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
		
		segmentedControl.addTarget(self, action: #selector(changeView), for: .valueChanged)
		
		initializeTableView()
		
		let articlesRefreshControl = UIRefreshControl.init()
		
		articlesRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
		
		refreshControl = articlesRefreshControl
		
		if articles.count == 0 {
			// Load articles from RSS feed
			loadArticles()
		}
	}
	
	///
	/// Handle moving between “News” and “Förderverein”
	///
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
	
	///
	/// Set up table view
	///
	private func initializeTableView() {
		tableView.register(SimpleFeedTableViewCell.self, forCellReuseIdentifier: "SimpleFeedTableViewCell")
		
		tableView.estimatedRowHeight = 97
		tableView.rowHeight = UITableView.automaticDimension
		
		tableView.backgroundColor = UIColor.groupTableViewBackground
		tableView.separatorColor = UIColor.clear
		tableView.separatorStyle = .none
	}
	
	///
	/// Refresh control action
	///
	@objc private func refresh() {
		// Reset current feed page
		feedPage = 1
		
		// Reload articles from feed
		loadArticles()
		
		if refreshControl!.isRefreshing {
			refreshControl?.endRefreshing()
		}
	}
	
	///
	/// Load articles from feed
	///
	private func loadArticles() {
		let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
		
		if reachabilityStatus != NotReachable {
			download(completion: { (items) in
				if self.feedPage == 1 {
					// If current feed page is 1, reload all articles of this page
					self.articles = items
				} else {
					// If current feed page is > 1, add articles of this page
					self.articles.append(contentsOf: items)
				}
				
				self.tableView.reloadData()
				
				// Initialize “Load more” activity indicator
				self.loadMoreActivityIndicator = LoadMoreActivityIndicator(scrollView: self.tableView, spacingFromLastCell: 10, spacingFromLastCellWhenLoadingStarts: 60)
			})
		} else {
			// Show message that there is no internet connection only if no articles have been loaded
			if articles.count == 0 {
				let noConnectionView = NoConnectionView()
				
				noConnectionView.textLabel.attributedText = noConnectionView.defaultText()
				
				tableView.backgroundColor = UIColor.groupTableViewBackground
				tableView.separatorStyle = .none
				tableView.backgroundView = noConnectionView
			}
		}
	}
	
	///
	/// Download articles from RSS feed and put their data into a dictionary
	///
	private func download(completion: @escaping (_ articles: [[String: String]]) -> ()) {
		let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
		
		if reachabilityStatus != NotReachable {
			var urlString = "https://svelg.wordpress.com/feed"
			
			if feedPage > 1 {
				urlString += "/?paged=\(feedPage)"
			}
			
			var request = URLRequest(url: URL(string: urlString)!)
			
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
						/*let responseErrorAlertController = UIAlertController(title: "Server-Fehler", message: "Die Artikel konnten nicht geladen werden.", preferredStyle: .alert)
						
						responseErrorAlertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
							self.dismiss(animated: true, completion: nil)
						}))
						
						self.present(responseErrorAlertController, animated: true, completion: nil)*/
						
						// Decrement current feed page
						self.feedPage -= 1
						
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
	
	///
	/// Reformat article’s date
	///
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

// MARK: - Extensions

extension FoerdervereinViewController {
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
			if loadMoreActivityIndicator != nil {
				// Start “Load more” activity indicator
				loadMoreActivityIndicator.start {
				DispatchQueue.global(qos: .utility).async {
					// Load more articles from next feed page
					self.feedPage += 1
					self.loadArticles()
					
					// Let activity indicator animate for a second to prevent animation glitches
					sleep(1)
					
					DispatchQueue.main.async { [weak self] in
						self?.loadMoreActivityIndicator.stop()
					}
				}
			}
		}
	}
}
