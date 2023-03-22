//
//  ScheduleListItemView.swift
//  ELG
//
//  Created by Johannes Jakob on 22/03/2023
//  Copyright © 2023 Elisabeth-Gymnasium Halle. All rights reserved.
//

import SwiftUI

struct ScheduleListItemView: View {
	let isEditing: Bool
	let index: Int
	let subject: Subjects
	let room: String?
	
	var body: some View {
		HStack {
			Label {
				Text(subject.rawValue)
					.foregroundColor(.primary)
			} icon: {
				if (!isEditing) {
					Image(systemName: "\(index + 1).circle.fill")
						.foregroundColor(Color(uiColor: .tertiaryLabel))
						.imageScale(.large)
				}
			}
			Spacer()
			if let room = room {
				Text(room)
					.foregroundColor(.secondary)
			}
		}
	}
}

struct ScheduleListItemView_Previews: PreviewProvider {
	static var previews: some View {
		ScheduleListItemView(isEditing: false, index: 0, subject: .none, room: nil)
	}
}
