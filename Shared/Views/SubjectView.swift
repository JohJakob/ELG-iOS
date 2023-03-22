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
	
	@Binding var weekday: Weekday
	@Binding var showSubjectModal: Bool
	@Binding var selectedLesson: Int?
	@Binding var selectedSubject: Subjects
	
	@State var showRoomInputAlert = false
	@State var room = ""
	
	var body: some View {
		NavigationView {
			List {
				Section {
					Button {
						updateLesson(scheduleCollection: scheduleCollection, weekday: weekday, lesson: selectedLesson, subject: .none, room: nil)
						self.showSubjectModal.toggle()
					} label: {
						HStack {
							Text(Subjects.none.rawValue)
							if (selectedSubject == .none && selectedLesson != nil) {
								Spacer()
								Image(.checkmark)
									.foregroundColor(Color("AccentColor"))
							}
						}
					}
					.foregroundColor(.primary)
				}
				Section {
					ForEach(Subjects.allCases.sorted(by: { $0.rawValue < $1.rawValue })) { subject in
						if (subject != .none) {
							Button {
								showRoomInputAlert = true
							} label: {
								HStack {
									Text(subject.rawValue)
									if (selectedSubject == subject) {
										Spacer()
										Image(.checkmark)
											.foregroundColor(Color("AccentColor"))
									}
								}
							}
							.foregroundColor(.primary)
							.alert("Enter Room Number", isPresented: $showRoomInputAlert, actions: {
								TextField("Room Number", text: $room)
									.keyboardType(.numberPad)
								Button("OK", action: {
									updateLesson(scheduleCollection: scheduleCollection, weekday: weekday, lesson: selectedLesson, subject: subject, room: room)
									self.showSubjectModal.toggle()
								})
							}, message: {
								Text("Please enter a room number for this lesson or continue without.")
							})
						}
					}
				}
			}
			.navigationTitle("Select Subject")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				Button("Cancel") {
					self.showSubjectModal.toggle()
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
	@State static var weekday = Weekday.monday
	@State static var showSubjectModal = true
	@State static var selectedLesson: Int? = nil
	@State static var selectedSubject = Subjects.none
	
	static var previews: some View {
		SubjectView(scheduleCollection: ScheduleCollection(), weekday: $weekday, showSubjectModal: $showSubjectModal, selectedLesson: $selectedLesson, selectedSubject: $selectedSubject)
	}
}
