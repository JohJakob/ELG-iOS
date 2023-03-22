//
//  ScheduleCollection.swift
//  ELG
//
//  Created by Johannes Jakob on 21/03/2023
//  Copyright © 2023 Elisabeth-Gymnasium Halle. All rights reserved.
//

import Foundation
import Defaults

class ScheduleCollection: ObservableObject {
	private let emptySchedule: [Weekday.RawValue: Schedule] = [Weekday.monday.rawValue: Schedule(entries: []), Weekday.tuesday.rawValue: Schedule(entries: []), Weekday.wednesday.rawValue: Schedule(entries: []), Weekday.thursday.rawValue: Schedule(entries: []), Weekday.friday.rawValue: Schedule(entries: [])]
	
	@Published var items: [Weekday.RawValue: Schedule] {
		didSet {
			Defaults[.scheduleCollection] = items
		}
	}
	
	subscript(key: Weekday) -> Schedule {
		get {
			return self.items[key.rawValue] ?? emptySchedule[key.rawValue]!
		}
		set(newValue) {
			self.items[key.rawValue] = newValue
		}
	}
	
	init() {
		self.items = Defaults[.scheduleCollection]
	}
}
