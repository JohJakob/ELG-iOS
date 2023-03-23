//
//  SubstitutionsError.swift
//  ELG
//
//  Created by Johannes Jakob on 22/03/2023
//  Copyright © 2023 Elisabeth-Gymnasium Halle. All rights reserved.
//

import Foundation

enum SubstitutionsError: Error {
	case loadingFailed
	case processingFailed
	case genericError
	case invalidURL
	
	var description: String {
		switch self {
		case .loadingFailed:
			return "An error occured while trying to receive new substitutions data."
		case .processingFailed:
			return "An error occured while trying to process new substitutions data."
		case .genericError:
			return "An error occured while trying to update or process new substitutions data."
		case .invalidURL:
			return "The substitutions CSV file URL is invalid."
		}
	}
}
