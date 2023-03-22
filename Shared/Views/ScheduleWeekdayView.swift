//
//  ScheduleWeekdayView.swift
//  ELG
//
//  Created by Johannes Jakob on 18/03/2023
//  Copyright © 2023 Elisabeth-Gymnasium Halle. All rights reserved.
//

import SwiftUI

struct ScheduleWeekdayView: View {
	var body: some View {
		NavigationView {
			List(Weekday.allCases) {
				NavigationLink($0.rawValue, destination: ScheduleView(weekday: $0, selectedSubject: Subjects.none))
			}
		}
	}
}

struct ScheduleWeekdayView_Previews: PreviewProvider {
	static var previews: some View {
		ScheduleWeekdayView()
	}
}
