//
//  OmissionsViewController.swift
//  ELG
//
//  Created by Johannes Jakob on 21/07/2016
//  © Elisabeth-Gymnasium Halle, Johannes Jakob
//

import UIKit
import ColorCompatibility

class OmissionsViewController: UITableViewController {
	// MARK: - Properties
	
	@IBOutlet weak fileprivate var saveButton: UIBarButtonItem!
	
	var defaults: UserDefaults!
	var selectedGrade = Int()
	var rows = [String]()
	var userPlan = [String]()
	var offlineAvailable = Bool()
	var autoSave = Bool()
	var teacherMode = Bool()
	var teacherToken = String()
	let grades = ["Keine Klasse", "5a", "5b", "5c", "5d", "5e", "6a", "6b", "6c", "6d", "6e", "7a", "7b", "7c", "7d", "7e", "8a", "8b", "8c", "8d", "8e", "9a", "9b", "9c", "9d", "9e", "10a", "10b", "10c", "10d", "10e", "11a", "11b", "11c", "11d", "11e", "12a", "12b", "12c", "12d", "12e"]
	
	@IBAction func saveButtonTap(_ sender: UIBarButtonItem) {
		saveOmissions()
	}
	
	// MARK: - UITableViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		defaults = UserDefaults.init(suiteName: "group.com.johjakob.elg")
		
		tableView.register(UINib(nibName: "OmissionsTableViewCell", bundle: nil), forCellReuseIdentifier: "OmissionsTableViewCell")
		
		let planRefreshControl = UIRefreshControl.init()
		
		planRefreshControl.addTarget(self, action: #selector(OmissionsViewController.refreshTableView), for: .valueChanged)
		
		refreshControl = planRefreshControl
		
		getUserDefaults()
		
		if offlineAvailable {
			getOfflinePlan()
		} else {
			downloadPlan()
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
		print("Memory Warning")
	}
	
	// MARK: - UITableView
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		var numberOfSections: Int
		
		let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
		
		if reachabilityStatus != NotReachable || (reachabilityStatus == NotReachable && offlineAvailable) {
			numberOfSections = 2
			
			// Remove background view
			tableView.backgroundView = nil
		} else {
			numberOfSections = 0
			
			let noConnectionView = NoConnectionView()
			
			noConnectionView.textLabel.attributedText = noConnectionView.defaultText()
			
			tableView.backgroundColor = UIColor.groupTableViewBackground
			tableView.separatorStyle = .none
			tableView.backgroundView = noConnectionView
		}
		
		return numberOfSections
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		var numberOfRows: Int
		
		if section == 0 {
			numberOfRows = userPlan.count
		} else {
			if rows.count < 3 {
				numberOfRows = 0
			} else {
				numberOfRows = rows.count - 2
			}
		}
		
		return numberOfRows
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "OmissionsTableViewCell", for: indexPath) as! OmissionsTableViewCell
		
		// Use AccentColor on iOS 11+
		
		if #available(iOS 11, *) {
			cell.gradeLabel.textColor = UIColor(named: "AccentColor")
		}
		
		var planComponents: [String]
		
		if indexPath.section == 0 {
			planComponents = (userPlan[indexPath.row] as AnyObject).components(separatedBy: "\",\"")
		} else {
			planComponents = (rows[indexPath.row + 1] as AnyObject).components(separatedBy: "\",\"")
		}
		
		let grade = planComponents[0].replacingOccurrences(of: "\"", with: "")
		let lesson = planComponents[1]
		let teacher = planComponents[2]
		let subject = planComponents[3]
		let room = planComponents[4]
		let text = planComponents[5]
		let comment = planComponents[6].replacingOccurrences(of: "\"", with: "")
		
		if grade.count < 4 {
			cell.gradeLabel.text = grade
		} else {
			if grade.first == "1" {
				let index = grade.index(grade.startIndex, offsetBy: 2)
				
				cell.gradeLabel.text = String(grade[..<index])
			} else {
				let index = grade.index(grade.startIndex, offsetBy: 1)
				
				cell.gradeLabel.text = String(grade[..<index])
			}
		}
		
		if subject == "" && teacher == "" {
			cell.lessonLabel.text = lesson + ". Stunde"
		} else if subject == "" {
			cell.lessonLabel.text = lesson + ". Stunde" + " (" + teacher + ")"
		} else if teacher == "" {
			cell.lessonLabel.text = lesson + ". Stunde" + ": " + subject
		} else {
			cell.lessonLabel.text = lesson + ". Stunde" + ": " + subject + " (" + teacher + ")"
		}
		
		if room == "" {
			cell.detailsLabel.text = text + "   " + comment
		} else {
			cell.detailsLabel.text = "Raum " + room + "   " + text + "   " + comment
		}
		
		cell.detailsLabel.text = cell.detailsLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines)
		
		cell.detailsLabel.text = cell.detailsLabel.text?.replacingOccurrences(of: "      ", with: "   ")
		
		if comment == "Entfall" {
			if #available(iOS 11, *) {
				cell.lessonLabel.textColor = UIColor(named: "AccentColor")
			} else {
				cell.lessonLabel.textColor = UIColor(red: 0.498, green: 0.09, blue: 0.203, alpha: 1)
			}
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 65
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		var titleForHeader: String
		
		if section == 0 {
			titleForHeader = "Eigene Vertretungen"
		} else {
			titleForHeader = "Alle Vertretungen"
		}
		
		return titleForHeader
	}
	
	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let footerLabel = UILabel()
		
		footerLabel.textColor = ColorCompatibility.secondaryLabel
		
		footerLabel.font = .boldSystemFont(ofSize: 18)
		footerLabel.textAlignment = .center
		
		footerLabel.backgroundColor = ColorCompatibility.systemBackground
		
		if section == 0 {
			if userPlan.count == 0 {
				footerLabel.text = "Keine eigenen Vertretungen"
			}
		} else {
			if rows.count < 3 {
				footerLabel.text = "Keine Vertretungen"
			}
		}
		
		return footerLabel
	}
	
	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		var heightForFooter: CGFloat = 0
		
		if section == 0 {
			if userPlan.count == 0 {
				heightForFooter = 44
			} else {
				heightForFooter = 0
			}
		} else {
			if rows.count < 3 {
				heightForFooter = 44
			} else {
				heightForFooter = 0
			}
		}
		
		return heightForFooter
	}
	
	// MARK: - Private
	
	private func getUserDefaults() {
		selectedGrade = defaults.integer(forKey: "grade")
		offlineAvailable = defaults.bool(forKey: "offlineAvailable")
		autoSave = defaults.bool(forKey: "autoSave")
		teacherMode = defaults.bool(forKey: "teacherMode")
		teacherToken = defaults.string(forKey: "teacherToken")!
	}
	
	@objc private func refreshTableView() {
		getUserDefaults()
		
		downloadPlan()
		
		tableView.reloadData()
		
		refreshControl?.endRefreshing()
	}
	
	private func getOfflinePlan() {
		rows = defaults.stringArray(forKey: "offlineOmissions") ?? []
		userPlan = defaults.stringArray(forKey: "ownOfflineOmissions") ?? []
		
		// Set navigation item title
		setTitle(with: rows[0])
		
		saveButton.isEnabled = false
	}
	
	private func downloadPlan() {
		let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
		
		if reachabilityStatus != NotReachable {
			var rawPlan = String()
			
			do {
				try rawPlan = String(contentsOf: URL.init(string: "https://archiv.elg-halle.de/Aktuell/Intern/Vertretungsplan/vp.csv")!, encoding: String.Encoding.ascii)
			} catch {
				print(error)
			}
			
			let cleanedPlan = rawPlan.replacingOccurrences(of: "\r", with: "")
			
			rows = cleanedPlan.components(separatedBy: "\n")
			
			userPlan = [String]()
			
			rows.removeAll { $0.contains("MIPa") }
			
			for i in 1 ..< rows.count - 1 {
				let planComponents = (rows[i] as AnyObject).components(separatedBy: "\",\"")
				let grade = planComponents[0].replacingOccurrences(of: "\"", with: "")
				var teacher = String()
				
				if planComponents.count >= 3 {
					teacher = planComponents[2]
				}
				
				if teacherMode {
					if teacher == teacherToken && teacher != "" {
						userPlan.append(rows[i])
					}
				} else {
					if selectedGrade != 0 {
						if grade.range(of: grades[selectedGrade]) != nil {
							userPlan.append(rows[i])
						}
					}
				}
			}
			
			// Set navigation item title
			setTitle(with: rows[0])
			
			tableView.separatorStyle = .singleLine
			
			offlineAvailable = false
			
			defaults.set(offlineAvailable, forKey: "offlineAvailable")
			defaults.synchronize()
			
			if rows.count < 3 {
				saveButton.isEnabled = false
			} else {
				saveButton.isEnabled = true
			}
			
			if autoSave {
				saveOmissions()
			}
		} else {
			saveButton.isEnabled = false
			
			tableView.separatorStyle = .none
		}
	}
	
	private func saveOmissions() {
		let reachabilityStatus: NetworkStatus = Reachability.forInternetConnection().currentReachabilityStatus()
		
		if reachabilityStatus != NotReachable {
			offlineAvailable = true
			
			defaults.set(rows, forKey: "offlineOmissions")
			defaults.set(userPlan, forKey: "ownOfflineOmissions")
			defaults.set(offlineAvailable, forKey: "offlineAvailable")
			defaults.synchronize()
			
			saveButton.isEnabled = false
		} else {
			saveButton.isEnabled = false
			
			let noConnectionAlertController = UIAlertController(title: "Keine Internetverbindung", message: "Es besteht keine Verbindung zum Internet. Dadurch kann der Vertretungsplan nicht gesichert werden. Bitte überprüfe Deine Einstellungen.", preferredStyle: .alert)
			noConnectionAlertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
				self.dismiss(animated: true, completion: nil)
			}))
			
			present(noConnectionAlertController, animated: true, completion: nil)
		}
	}
	
	///
	/// Set navigation item title
	///
	private func setTitle(with dateString: String) {
		let dateFormatter = DateFormatter()
		var datePrefix = String()
		var title = String()
		
		// Create date from date string in cover plan
		dateFormatter.dateFormat = "dd.MM.yyyy"
		let date = dateFormatter.date(from: dateString)
		
		if Calendar.current.isDateInToday(date!) {
			datePrefix = "Heute, "
		} else if Calendar.current.isDateInTomorrow(date!) {
			datePrefix = "Morgen, "
		} else if Calendar.current.isDateInYesterday(date!) {
			datePrefix = "Gestern, "
		} else {
			datePrefix = ""
		}
		
		title = datePrefix + dateString
		
		navigationItem.title = title
	}
}
