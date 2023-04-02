//
//  SubstitutionItemCard.swift
//  ELG
//
//  Created by Johannes Jakob on 23/03/2023
//  Copyright © 2023 Elisabeth-Gymnasium Halle. All rights reserved.
//

import SwiftUI

struct SubstitutionItemCard: View {
	let item: SubstitutionItem
	
	let dataFont = Font.system(size: 32).monospaced()
	let smallDataFont = Font.system(size: 24).monospaced()
	let tinyDataFont = Font.system(size: 14)
	let padding: CGFloat = 8
	
	var body: some View {
		HStack(alignment: .top, spacing: 8) {
			VStack(alignment: .leading) {
				Text("Classes".uppercased())
					.font(.caption2)
					.foregroundColor(.secondary)
				SubstitutionSchoolClassView(classes: item.schoolClass)
			}
			.padding([.top, .bottom], padding)
			VerticalDivider()
				.stroke(style: StrokeStyle(lineWidth: 0.25, dash: [4]))
				.foregroundColor(.secondary)
				.frame(width: 1)
			VStack(alignment: .leading) {
				Text("Lesson".uppercased())
					.font(.caption2)
					.foregroundColor(.secondary)
				Text(item.lesson)
					.font(dataFont)
			}
			.padding([.top, .bottom], padding)
			Divider()
			VStack(alignment: .leading, spacing: 4) {
				VStack(alignment: .leading) {
					Text("Subject".uppercased())
						.font(.caption2)
						.foregroundColor(.secondary)
					Text(item.subject)
						.font(dataFont)
				}
				if (!item.teacher.isNil && item.teacher != "") {
					VStack(alignment: .leading) {
						Text("Teacher".uppercased())
							.font(.caption2)
							.foregroundColor(.secondary)
						Text(item.teacher!)
							.foregroundColor(.secondary)
							.font(smallDataFont)
					}
				}
				if (!item.text.isNil && item.text != "") {
					VStack(alignment: .leading) {
						Text("Text".uppercased())
							.font(.caption2)
							.foregroundColor(.secondary)
						Text(item.text!)
							.font(tinyDataFont)
					}
				}
				if (!item.note.isNil && item.note != "") {
					VStack(alignment: .leading) {
						Text("Note".uppercased())
							.font(.caption2)
							.foregroundColor(.secondary)
						Text(item.note!)
							.font(tinyDataFont)
					}
				}
			}
			.padding([.top, .bottom], padding)
		}
		.padding([.leading, .trailing], padding)
	}
}

struct VerticalDivider: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		path.move(to: CGPoint(x: 0, y: 0))
		path.addLine(to: CGPoint(x: 0, y: rect.height))
		return path
	}
}

func ordinalNumber(for number: Int) -> String {
	let numberFormatter = NumberFormatter()
	numberFormatter.numberStyle = .ordinal
	
	return numberFormatter.string(from: number as NSNumber)!
}

/*struct SubstitutionListItemView_Previews: PreviewProvider {
	@State var item = SubstitutionItem(schoolClass: "5a", lesson: "1", teacher: "KRA", subject: "PH", room: "108", text: "Aufgaben Teams", note: "Aufgaben")
	
	static var previews: some View {
		SubstitutionListItemView()
	}
}*/
