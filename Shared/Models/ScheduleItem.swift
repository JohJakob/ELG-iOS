//
//  ScheduleItem.swift
//  ELG
//
//  Created by Johannes Jakob on 18/03/2023
//  Copyright © 2023 Elisabeth-Gymnasium Halle. All rights reserved.
//

import Foundation
import Defaults

struct ScheduleItem: Codable, Identifiable, Defaults.Serializable {
	var id: UUID = UUID()
	
	var subject: Subjects = Subjects.none
	var room: String? = nil
}
