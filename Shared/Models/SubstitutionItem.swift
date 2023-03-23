//
//  SubstitutionItem.swift
//  ELG
//
//  Created by Johannes Jakob on 18/03/2023
//  Copyright © 2023 Elisabeth-Gymnasium Halle. All rights reserved.
//

import Foundation
import Defaults

struct SubstitutionItem: Codable, Identifiable, Defaults.Serializable {
	var id: UUID = UUID()
	
	var schoolClass: [String]
	var lesson: String
	var teacher: String? = nil
	var subject: String
	var room: String? = nil
	var text: String? = nil
	var note: String? = nil
}
