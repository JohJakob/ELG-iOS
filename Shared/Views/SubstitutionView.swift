//
//  SubstitutionView.swift
//  ELG
//
//  Created by Johannes Jakob on 22/03/2023
//  Copyright © 2023 Elisabeth-Gymnasium Halle. All rights reserved.
//

import SwiftUI
import SPIndicator

struct SubstitutionView: View {
	@EnvironmentObject var networkMonitor: NetworkMonitor
	@StateObject var substitutions = Substitutions()
	
	let today = Date()
	
	var body: some View {
		NavigationView {
			ZStack {
				Color(uiColor: .systemGroupedBackground)
					.ignoresSafeArea()
				VStack {
					if (substitutions.items.isEmpty) {
						Text("No substitutions")
							.font(.title2)
							.foregroundColor(.secondary)
					} else {
						List {
							Section {
								ForEach(substitutions.items) { item in
									SubstitutionItemCard(item: item)
								}
								.listRowSeparator(.hidden)
								.listRowBackground(
									RoundedRectangle(cornerRadius: 12)
										.fill(Color(uiColor: .secondarySystemGroupedBackground))
										.padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
								)
							}
						}
						.listStyle(.plain)
						.refreshable {
							if (networkMonitor.isConnected) {
								await substitutions.update()
							} else {
								let indicator = SPIndicatorView(title: "No Internet Connection", preset: .custom(UIImage(.wifi.slash).withTintColor(.red, renderingMode: .automatic)))
								indicator.present(duration: 2, haptic: .error)
							}
						}
					}
				}
			}
			.navigationTitle(
				Text("\(substitutions.relativeDate()), \(substitutions.date.formatted(date: .abbreviated, time: .omitted))")
			)
			.navigationBarTitleDisplayMode(.inline)
		}
		.task {
			if (networkMonitor.isConnected) {
				await substitutions.update()
			}
		}
	}
}

struct SubstitutionView_Previews: PreviewProvider {
	static var previews: some View {
		SubstitutionView()
	}
}
