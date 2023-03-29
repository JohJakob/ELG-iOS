//
//  SubjectView.swift
//  ELG
//
//  Created by Johannes Jakob on 18/03/2023
//  Copyright © 2023 Elisabeth-Gymnasium Halle. All rights reserved.
//

import SwiftUI
import SafeSFSymbols

struct SubjectView: View {
	@ObservedObject var scheduleCollection: ScheduleCollection
	@Binding var showSubjectModal: Bool
	let weekday: Weekday
	let selectedLesson: Int?
	let previousSubject: Subjects
	
	@State var showRoomInputAlert = false
	@State var newSubject = Subjects.none
	@State var room = ""
	
	var body: some View {
		NavigationView {
			List {
				Section {
					Button {
						updateLesson(scheduleCollection: scheduleCollection, weekday: weekday, lesson: selectedLesson, subject: .none, room: nil)
						self.showSubjectModal = false
					} label: {
						HStack {
							Text(Subjects.none.rawValue)
							if (previousSubject == .none && selectedLesson != nil) {
								Spacer()
								Image(.checkmark)
									.foregroundColor(Color("AccentColor"))
							}
						}
					}
					.foregroundColor(.primary)
				}
				Section {
					ForEach(Subjects.allCases.sorted(by: { $0.rawValue < $1.rawValue }), id: \.id) { subject in
						if (subject != .none) {
							Button {
								newSubject = subject
								showRoomInputAlert = true
							} label: {
								HStack {
									Text(subject.rawValue)
									if (previousSubject == subject) {
										Spacer()
										Image(.checkmark)
											.foregroundColor(Color("AccentColor"))
									}
								}
							}
							.foregroundColor(.primary)
						}
					}
				}
			}
			.alert("Enter Room Number", isPresented: $showRoomInputAlert, actions: {
				TextField("Room Number", text: $room)
					.keyboardType(.numberPad)
				Button("OK", action: {
					showRoomInputAlert = false
					updateLesson(scheduleCollection: scheduleCollection, weekday: weekday, lesson: selectedLesson, subject: newSubject, room: room)
					self.showSubjectModal = false
				})
			}, message: {
				Text("Please enter a room number for this lesson or continue without.")
			})
			.navigationTitle("Select Subject")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				Button("Cancel") {
					self.showSubjectModal = false
				}
			}
		}
	}
}

func updateLesson(scheduleCollection: ScheduleCollection, weekday: Weekday, lesson: Int?, subject: Subjects, room: String?) {
	if let lesson = lesson {
		scheduleCollection[weekday].entries.remove(at: lesson)
		scheduleCollection[weekday].entries.insert(ScheduleItem(subject: subject, room: room), at: lesson)
	} else {
		scheduleCollection[weekday].entries.append(ScheduleItem(subject: subject, room: room))
	}
}

struct SubjectView_Previews: PreviewProvider {
	@State static var showSubjectModal = true
	
	static var previews: some View {
		SubjectView(scheduleCollection: ScheduleCollection(), showSubjectModal: $showSubjectModal, weekday: .monday, selectedLesson: nil, previousSubject: .none)
	}
}
