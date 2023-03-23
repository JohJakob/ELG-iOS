//
//  NetworkMonitor.swift
//  ELG
//
//  Created by Johannes Jakob on 22/03/2023
//  Copyright © 2023 Elisabeth-Gymnasium Halle. All rights reserved.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
	private let networkMonitor = NWPathMonitor()
	private let workerQueue = DispatchQueue(label: "Monitor")
	var isConnected = false
	
	init() {
		networkMonitor.pathUpdateHandler = { path in
			self.isConnected = path.status == .satisfied
			Task {
				await MainActor.run {
					self.objectWillChange.send()
				}
			}
		}
		networkMonitor.start(queue: workerQueue)
	}
}
