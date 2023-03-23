//
//  ContentView.swift
//  ELG
//
//  Created by Johannes Jakob on 16/03/2023
//  Copyright © 2023 Elisabeth-Gymnasium Halle. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		let weekdayIndex = Calendar(identifier: .gregorian).component(.weekday, from: Date())
		let currentWeekday = getWeekday(for: weekdayIndex - 2) ?? .monday
		
		TabView {
			ScheduleView(weekday: currentWeekday, selectedSubject: .none)
				.tabItem {
					Label("Schedule", systemImage: "calendar")
				}
			SubstitutionView()
				.tabItem {
					Label("Substitutions", systemImage: "party.popper.fill")
				}
		}
	}
}

func getWeekday(for index: Int) -> Weekday? {
	Weekday.allCases.first(where: { $0.index == index })
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
