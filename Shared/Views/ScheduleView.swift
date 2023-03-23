//
//  ScheduleView.swift
//  ELG
//
//  Created by Johannes Jakob on 18/03/2023
//  Copyright © 2023 Elisabeth-Gymnasium Halle. All rights reserved.
//

import SwiftUI
import SafeSFSymbols

struct ScheduleView: View {
	@ObservedObject var scheduleCollection = ScheduleCollection()
	@State var weekday: Weekday
	@State var isEditing = false
	@State var selectedLesson: Int?
	@State var showSubjectModal = false
	@State var selectedSubject: Subjects
	
	var body: some View {
		NavigationView {
			ZStack {
				Color(uiColor: .systemGroupedBackground)
					.ignoresSafeArea()
				VStack {
					if (scheduleCollection[weekday].entries.isEmpty && !isEditing) {
						Text("No lessons")
							.foregroundColor(.secondary)
					} else {
						List {
							if (!scheduleCollection[weekday].entries.isEmpty) {
								Section {
									ForEach(scheduleCollection[weekday].entries.indices, id: \.self) { index in
										if (isEditing) {
											Button {
												selectedLesson = index
												selectedSubject = scheduleCollection[weekday].entries[index].subject
												showSubjectModal = true
											} label: {
												ScheduleListItemView(isEditing: isEditing, index: index, subject: scheduleCollection[weekday].entries[index].subject, room: scheduleCollection[weekday].entries[index].room)
											}
											.sheet(isPresented: $showSubjectModal) {
												SubjectView(scheduleCollection: scheduleCollection, weekday: $weekday, showSubjectModal: $showSubjectModal, selectedLesson: $selectedLesson, selectedSubject: $selectedSubject)
											}
										} else {
											ScheduleListItemView(isEditing: isEditing, index: index, subject: scheduleCollection[weekday].entries[index].subject, room: scheduleCollection[weekday].entries[index].room)
										}
									}
									.onMove { indexSet, offset in
										scheduleCollection[weekday].entries.move(fromOffsets: indexSet, toOffset: offset)
									}
									.onDelete { indexSet in
										scheduleCollection[weekday].entries.remove(atOffsets: indexSet)
									}
								}
							}
							if (isEditing && scheduleCollection[weekday].entries.count < 10) {
								Section {
									Button {
										selectedLesson = nil
										selectedSubject = .none
										showSubjectModal = true
									} label: {
										Label("Add lesson", systemImage: "plus")
									}
									.sheet(isPresented: $showSubjectModal) {
										SubjectView(scheduleCollection: scheduleCollection, weekday: $weekday, showSubjectModal: $showSubjectModal, selectedLesson: $selectedLesson, selectedSubject: $selectedSubject)
									}
								}
							} else if (isEditing && scheduleCollection[weekday].entries.count == 10) {
								Text("10 lessons? That’s tough.")
									.foregroundColor(.secondary)
							}
						}
					}
				}
				.environment(\.editMode, .constant(isEditing ? .active : .inactive))
				.listStyle(InsetGroupedListStyle())
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .principal) {
					HStack(spacing: 0) {
						Menu {
							ForEach(Weekday.allCases) { day in
								Button {
									weekday = day
								} label: {
									Label {
										Text(day.rawValue)
									} icon: {
										if (day == weekday) {
											Image(.checkmark)
										}
									}
								}
							}
						} label: {
							HStack {
								Text(weekday.rawValue)
									.font(.headline)
									.foregroundColor(.primary)
								Image(.chevron.down)
									.imageScale(.medium)
									.foregroundColor(isEditing ? .secondary : .primary)
							}
						}
						.disabled(isEditing)
					}
				}
				ToolbarItem {
					Button(isEditing ? "Done" : "Edit") {
						isEditing.toggle()
					}
				}
			}
		}
	}
}

struct ScheduleView_Previews: PreviewProvider {
	static var previews: some View {
		ScheduleView(weekday: .monday, selectedSubject: .none)
	}
}
