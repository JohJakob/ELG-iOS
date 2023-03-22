//
//  SubstitutionItem.swift
//  ELG
//
//  Created by Johannes Jakob on 18/03/2023
//  Copyright © 2023 Elisabeth-Gymnasium Halle. All rights reserved.
//

import Foundation
import Defaults

struct SubstitutionItem: Codable, Defaults.Serializable {
	var schoolClass: String? = nil
	var lesson: String? = nil
	var substitution: String? = nil
	var subject: String? = nil
	var room: String? = nil
	var text: String? = nil
	var note: String? = nil
}
