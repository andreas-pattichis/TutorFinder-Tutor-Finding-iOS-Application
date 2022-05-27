//
//  CourseRegister.swift
//  TutorFind
//
//  Created by Andreas Loizides on 28/11/2021.
//

import Foundation
struct CourseRegister: DictionaryCodable, StorableOnFirebase{
	var id: String = "\(UUID())"
	var studentID = ""
	var professorID = ""
	var courseID = ""
	var date = Date()
	static var basePathString: String = "course-registers"
	static var genericName: String = "Εγγραφή σε Μάθημα"
	func toDict() -> [String : Any] {
		return [
			"studentID":studentID
			,"professorID":professorID
			,"courseID":courseID
			,"date":date.toString()
		]
	}
	init(){}
	init?(id: String, dict: [String : Any]) {
		self.id=id
		guard let dateString = dict["date"] as? String
				,let date = Date.fromString(string: dateString)
				,let professorID = dict["professorID"] as? String
				,let courseID = dict["courseID"] as? String
				,let studentID = dict["studentID"] as? String else{
					return nil
				}
		self.date=date
		self.studentID=studentID
		self.professorID=professorID
		self.courseID=courseID
	}
	
}
