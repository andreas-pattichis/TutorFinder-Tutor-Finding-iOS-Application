
import Foundation
import SwiftUI
import UIKit
import Firebase

enum Day: String, CaseIterable, Identifiable, Codable{
	case Monday = "Δευτέρα"
	case Tuesday = "Τρίτη"
	case Wednesday = "Τετάρτη"
	case Thursday = "Πέμπτη"
	case Friday = "Παρασκευή"
	case Saturday = "Σάββατο"
	case Sunday = "Κυριακή"
	var id:String {return rawValue}
	func getPrefix()->String{
		return String(self.rawValue.prefix(3))
	}
	func dayInWeekStartingAtZeroOfCourse()->Int{
		switch self{
		case .Monday: return 0
		case .Tuesday: return 1
		case .Wednesday: return 2
		case .Thursday: return 3
		case .Friday: return 4
		case .Saturday: return 5
		case .Sunday: return 6
		}
	}
}

struct Course:Identifiable, Hashable{
	init?(id: String, dictionary: [String: Any]){
		guard let title = dictionary["title"] as? String
				,let length = dictionary["lengthInMinutes"] as? Int
				,let frequencyAsStrings = dictionary["frequency"] as? [String]
				,let colorHex = dictionary["color"] as? String
				,let color = Color(hexString: colorHex)
				,let teacherID = dictionary["teacherID"] as? String
				,let teacher = dictionary["teacher"] as? String
				,let startTimeString = dictionary["startTime"] as? String
				,let taksiString = dictionary["taksi"] as? String
				,let schoolTypeString = dictionary["schoolType"] as? String
				,let classTypeString = dictionary["classType"] as? String
		else {return nil}
		
		let freq = frequencyAsStrings.compactMap{Day(rawValue: $0)}
		guard frequencyAsStrings.count == freq.count else {return nil}
		self.id=id
		self.title=title
		self.lengthInMinutes=length
		self.frequency=freq
		self.color=color
		self.teacherID=teacherID
		self.teacherName=teacher
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		guard let startTime = dateFormatter.date(from: startTimeString)
				,let taksi = Taksi(rawValue: taksiString)
				,let schoolType = SchoolType(rawValue: schoolTypeString)
				, let classType = ClassType(rawValue: classTypeString) else{return nil}
		self.startTime=startTime
		self.taksi=taksi
		self.schoolType=schoolType
		self.classType = classType
	}
	init(id: String, title: String, teacherID: String, teacherName: String, attendees: [String: String], length: Int, freq: [Day], color: Color ,startTime: Date, taksi: Taksi, schoolType: SchoolType, classType: ClassType
	){
		self.id=id
		self.title=title
		self.teacherID=teacherID
		self.teacherName=teacherName
		self.lengthInMinutes=length
		self.frequency=freq
		self.color=color
		self.startTime=startTime
		self.schoolType=schoolType
		self.taksi=taksi
		self.classType=classType
	}
	func toDictionary()->[String: Any]{
		var dictionary = [String: Any]()
		
		dictionary["title"] = title
		dictionary["lengthInMinutes"] = lengthInMinutes
		dictionary["frequency"] = frequency.map{$0.rawValue}
		dictionary["color"] = color.toHexString()
		dictionary["teacherID"] = teacherID
		dictionary["teacher"] = teacherName
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		dictionary["startTime"] = dateFormatter.string(from: startTime)
		dictionary["taksi"] = taksi.rawValue
		dictionary["schoolType"] = schoolType.rawValue
		dictionary["classType"] = classType.rawValue
		return dictionary
	}
	init(){}
	
	
	var id: String = "\(UUID())"
	var title: String = ""
	var teacherID: String = ""
	var teacherName: String = ""
	var lengthInMinutes: Int = 0
	var frequency: [Day] = [.Monday, .Thursday]
	var color: Color = .blue
	var startTime: Date = Date()
	var taksi: Taksi = .a
	var schoolType: SchoolType = .lykeio
	var classType: ClassType = .cs
}
extension Course {
	static var data: [Course] {
		[
			Course(id: "BIO1", title: "Biology", teacherID: "T1", teacherName: "Maria Panagiotou", attendees: [
				"petAnd":"Petros Andreou"
				,"marPet":"Marios Petrou"
				,"zenMar":"Zenios Mariou"
			], length: 120, freq: [.Monday, .Thursday], color: .green, startTime: Date(), taksi: .a, schoolType: .lykeio, classType: .biology),
			Course(id: "BIO2", title: "Biology", teacherID: "T1", teacherName: "Maria Panagiotou", attendees: ["kat":"Katie", "gray":"Gray", "euna":"Euna", "luis":"Luis", "darl":"Darla"], length: 120, freq: [.Tuesday, .Friday], color: .green, startTime: Date(), taksi: .b, schoolType: .lykeio, classType: .biology),
			Course(id: "MA01", title: "Math", teacherID: "T2", teacherName: "Marios Panagiotou", attendees: ["kat":"Katie", "gra":"Gray", "eun":"Euna", "luis":"Luis", "darl":"Darla"], length: 90, freq: [.Monday, .Thursday], color: .purple, startTime: Date(), taksi: .g, schoolType: .lykeio, classType: .math),
			Course(id: "NE01", title: "Nea", teacherID: "T3", teacherName: "John Doe", attendees: ["chel":"Chella", "chr":"Chris", "chris":"Christina", "eden":"Eden", "karl":"Karla", "lind":"Lindsey", "aga":"Aga", "chad":"Chad", "jenn":"Jenn", "sar":"Sarah"], length: 90, freq: [.Tuesday, .Friday], color: .red, startTime: Date(), taksi: .a, schoolType: .gymnasio, classType: .nea)
		]
	}
}
extension Course: StorableOnFirebase, DictionaryCodable{
	static var basePathString: String = "courses"
	static var genericName: String = "Ακροατήριο"
	init?(id: String, dict: [String : Any]) {
		self.init(id: id, dictionary: dict)
	}
	func toDict() -> [String : Any] {
		return toDictionary()
	}
}
class CourseViewModel: MyViewModel<Course>{
	override func publishNewModel(customID: String? = nil) async -> Bool {
		guard let userID = UserVM.currentUser.getUserIDIfLoggedInOrShowMessageAndLogoutIfNot() else{return false}
		guard UserVM.currentUser.model.userType == .teacher else{
			return false
		}
		model.teacherID=userID
		model.teacherName=UserVM.currentUser.model.fullName
		let professorsCurrentCourses = ProfessorCoursesVM()
		professorsCurrentCourses.observeModel(id: userID)
		let published = await super.publishNewModel()
		if published{
			let courseID = model.id
			let profID = model.teacherID
			return await ProfessorCoursesVM.addCourseToProfessor(courseID: courseID, professorID: profID)
		}else{
			return false
		}
	}
}
