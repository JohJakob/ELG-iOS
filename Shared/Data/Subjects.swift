//
//  Subjects.swift
//  ELG
//
//  Created by Johannes Jakob on 18/03/2023
//  Copyright © 2023 Elisabeth-Gymnasium Halle. All rights reserved.
//

import Foundation
import Defaults

enum Subjects: String, Codable, Identifiable, CaseIterable, Defaults.Serializable {
	var id: String { self.rawValue }
	
	case none = "No Class"
	case arts = "Arts"
	case astronomy = "Astronomy"
	case biology = "Biology"
	case chemistry = "Chemistry"
	case computerScience = "Computer Science"
	case economics = "Economics"
	case english = "English"
	case ethics = "Ethics"
	case extra = "Extra Lesson"
	case french = "French"
	case geography = "Geography"
	case german = "German"
	case history = "History"
	case interconnectedScientificEducation = "Interconnected Scientific Education"
	case juniorEngineerAcademy = "Junior Engineer Academy"
	case latin = "Latin"
	case lawStudies = "Law Studies"
	case mathematics = "Mathematics"
	case mediaStudies = "Media Studies"
	case methodTraining = "Method Training"
	case music = "Music"
	case physicalEducation = "Physical Education"
	case physics = "Physics"
	case religion = "Religion"
	case russian = "Russian"
	case seatwork = "Seatwork"
	case socialStudies = "Social Studies"
	case spanish = "Spanish"

}
