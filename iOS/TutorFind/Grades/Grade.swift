import Foundation
import Firebase
struct Grade: Codable, DictionaryCodable, StorableOnFirebase, Hashable{

	var id = ""
	var studentID = ""
	var professorID = ""
	var courseID = ""
	var studentName = ""
	var professorName = ""
	var grade = ""
	var title = ""
	var comments = ""
	var courseName = ""
	var date = Date()
	static var basePathString: String = "grades"
	static var genericName: String = "Βαθμολογία"
	init(){}
	
	init?(id: String, dict: [String: Any]){
		guard
				let studentID = dict["studentID"] as? String
				,let professorID = dict["professorID"] as? String
				,let courseID = dict["courseID"] as? String
				,let studentName = dict["studentName"] as? String
				,let professorName = dict["professorName"] as? String
				,let grade = dict["grade"] as? String
				,let title = dict["title"] as? String
				,let comments = dict["comments"] as? String
				,let dateString = dict["date"] as? String
					,let courseName = dict["courseName"] as? String
				,let date = Date.fromString(string: dateString)
		else{return nil}
		self.id=id
		self.studentID=studentID
		self.courseID=courseID
		self.professorID=professorID
		self.studentName=studentName
		self.professorName=professorName
		self.grade=grade
		self.title=title
		self.comments=comments
		self.date=date
		self.courseName=courseName
	}
	func toDict()->[String: Any]{
		var dict = [String:Any]()
		dict["studentID"] = studentID
		dict["professorID"] = professorID
		dict["studentName"] = studentName
		dict["professorName"] = professorName
		dict["grade"] = grade
		dict["title"] = title
		dict["courseID"] = courseID
		dict["comments"] = comments
		dict["date"]=date.toString()
		dict["courseName"]=courseName
		return dict
	}
}


