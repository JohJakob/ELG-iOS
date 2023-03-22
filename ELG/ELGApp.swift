//
//  ELGApp.swift
//  ELG
//
//  Created by Johannes Jakob on 16/03/2023
//  Copyright © 2023 Elisabeth-Gymnasium Halle. All rights reserved.
//

import SwiftUI
import Defaults

typealias Defaults = _Defaults
typealias Default = _Default

let emptySchedule: [Weekday.RawValue: Schedule] = [Weekday.monday.rawValue: Schedule(entries: []), Weekday.tuesday.rawValue: Schedule(entries: [ScheduleItem(subject: .arts), ScheduleItem(subject: .astronomy)]), Weekday.wednesday.rawValue: Schedule(entries: []), Weekday.thursday.rawValue: Schedule(entries: []), Weekday.friday.rawValue: Schedule(entries: [])]

let extensionDefaults = UserDefaults(suiteName: "group.com.johjakob.elg")!

extension Defaults.Keys {
	static let hasOnboarded = Key<Bool>("hasOnboarded", default: false, suite: extensionDefaults)
	static let scheduleCollection = Key<[Weekday.RawValue: Schedule]>("schedule", default: emptySchedule, suite: extensionDefaults)
}

@main
struct ELGApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
		}
	}
}
