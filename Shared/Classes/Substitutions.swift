//
//  Substitutions.swift
//  ELG
//
//  Created by Johannes Jakob on 22/03/2023
//  Copyright © 2023 Elisabeth-Gymnasium Halle. All rights reserved.
//

import Foundation
import Defaults
import SwiftCSV
import OSLog

final class Substitutions: ObservableObject {
	@Published var date: Date {
		didSet {
			let dateFormatter = DateFormatter()
			dateFormatter.locale = Locale(identifier: "en_US_POSIX")
			dateFormatter.dateFormat = "dd.MM.yyyy"
			let dateString = dateFormatter.string(from: date)
			
			Defaults[.substitutionsDate] = dateString
		}
	}
	
	@Published var items: [SubstitutionItem] {
		didSet {
			Defaults[.substitutions] = items
		}
	}
	
	@Published var error: SubstitutionsError? = nil
	
	init() {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = "dd.MM.yyyy"
		
		self.date = dateFormatter.date(from: Defaults[.substitutionsDate]) ?? Date()
		self.items = Defaults[.substitutions]
	}
	
	@MainActor
	final public func update() async {
		do {
			let csvURL = URL(string: "https://archiv.elg-halle.de/Aktuell/Intern/Vertretungsplan/vp.csv")
			
			var items: [SubstitutionItem] = []
			var dateString: String = ""
			let data: EnumeratedCSV = try await retrieveData(from: csvURL)
			
			dateString = data.header[0]
			
			data.rows.forEach { row in
				let schoolClasses = row[0].components(separatedBy: ", ")
				
				items.append(SubstitutionItem(schoolClass: schoolClasses, lesson: row[1], teacher: row[2], subject: row[3], room: row[4], text: row[5], note: row[6]))
			}
			
			let dateFormatter = DateFormatter()
			dateFormatter.locale = Locale(identifier: "en_US_POSIX")
			dateFormatter.dateFormat = "dd.MM.yyyy"
			
			self.date = dateFormatter.date(from: dateString) ?? self.date
			self.items = items
			self.error = nil
		} catch SubstitutionsError.genericError {
			self.error = .genericError
		} catch {
			os_log("An error occured when trying to update local substitutions data: \(error.localizedDescription)")
			self.error = .processingFailed
		}
	}
	
	public func relativeDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		dateFormatter.locale = Locale.current
		dateFormatter.doesRelativeDateFormatting = true
		
		return dateFormatter.string(from: self.date)
	}
	
	private func retrieveData(from csvURL: URL?) async throws -> EnumeratedCSV {
		if let csvURL = csvURL {
			do {
				return try CSV<Enumerated>(url: csvURL, encoding: .ascii, loadColumns: false)
			} catch {
				throw SubstitutionsError.loadingFailed
			}
		} else {
			throw SubstitutionsError.invalidURL
		}
	}
}
