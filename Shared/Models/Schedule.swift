//
//  Schedule.swift
//  ELG
//
//  Created by Johannes Jakob on 18/03/2023
//  Copyright © 2023 Elisabeth-Gymnasium Halle. All rights reserved.
//

import Foundation
import Defaults

struct Schedule: Codable, Defaults.Serializable {
	var entries: [ScheduleItem]
}
