//
//  SubstitutionSchoolClassView.swift
//  ELG
//
//  Created by Johannes Jakob on 23/03/2023
//  Copyright © 2023 Elisabeth-Gymnasium Halle. All rights reserved.
//

import SwiftUI
import SafeSFSymbols

struct SubstitutionSchoolClassView: View {
	let classes: [String]
	
	let dataFont = Font.system(size: 32).monospaced()
	let smallDataFont = Font.system(size: 24).monospaced()
	
	var body: some View {
		VStack {
			if (classes.count > 1 && classes.count < 5) {
				VStack(alignment: .leading, spacing: 4) {
					Text(classes.first!.padding(toLength: 3, withPad: " ", startingAt: 0))
					Image(.chevron.compactDown)
						.imageScale(.small)
						.foregroundColor(Color(uiColor: .tertiaryLabel))
					Text(classes.last!.padding(toLength: 3, withPad: " ", startingAt: 0))
				}
				.foregroundColor(.accentColor)
				.font(dataFont)
			} else if (classes.count == 5) {
				Text(String(classes.first!.dropLast()).padding(toLength: 3, withPad: " ", startingAt: 0))
					.foregroundColor(.accentColor)
					.font(dataFont)
			} else if (classes.count == 1) {
				Text(classes.first!.padding(toLength: 3, withPad: " ", startingAt: 0))
					.foregroundColor(.accentColor)
					.font(dataFont)
			} else {
				Text(classes.joined(separator: ", "))
					.foregroundColor(.accentColor)
					.font(dataFont)
			}
		}
	}
}

struct SubstitutionSchoolClassView_Previews: PreviewProvider {
	static var previews: some View {
		SubstitutionSchoolClassView(classes: ["12a", "12b", "12c", "12d"])
	}
}
