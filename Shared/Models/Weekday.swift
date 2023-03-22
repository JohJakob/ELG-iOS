//
//  Weekday.swift
//  ELG
//
//  Created by Johannes Jakob on 18/03/2023
//  Copyright © 2023 Elisabeth-Gymnasium Halle. All rights reserved.
//

import Foundation
import Defaults

enum Weekday: String, Codable, Identifiable, CaseIterable, Defaults.Serializable {
	var id: String { self.rawValue }
	var index: Int { Weekday.allCases.firstIndex(of: self) ?? 0 }
	
	case monday = "Monday"
	case tuesday = "Tuesday"
	case wednesday = "Wednesday"
	case thursday = "Thursday"
	case friday = "Friday"
}
