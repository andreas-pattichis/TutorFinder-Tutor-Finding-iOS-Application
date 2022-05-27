//
//  View to display the review view, created by Andreas Pattichis
//

import Foundation
import Firebase

struct Review: StorableOnFirebase, DictionaryCodable{
	static var basePathString: String = "reviews"
	static var genericName: String = "Κριτική"
	var id: String = "\(UUID())"
	var authorID = ""
	var author = ""
	var teacherID = ""
	var teacherName = ""
	var grade: Float = 0.0
	var title = ""
	var description = ""
	var date = Date()
	func toDict() -> [String : Any] {
		var dict = [String: Any]()
		
		dict["authorID"]=authorID
		dict["author"]=author
		dict["teacherID"]=teacherID
		dict["teacherName"]=teacherName
		dict["grade"]=grade
		dict["title"]=title
		dict["description"]=description
		dict["date"]=date.toString()
		return dict
	}
	init?(id: String, dict: [String : Any]) {
		guard let authorID = dict["authorID"] as? String
				,let author = dict["author"] as? String
				,let teacherID = dict["teacherID"] as? String
				,let teacherName = dict["teacherName"] as? String
				,let grade = dict["grade"] as? Float
				,let title = dict["title"] as? String
				,let description = dict["description"] as? String
				,let dateString = dict["date"] as? String
				, let date = Date.fromString(string: dateString) else {return nil}
		self.id=id
		self.authorID=authorID
		self.author=author
		self.teacherID=teacherID
		self.teacherName=teacherName
		self.grade=grade
		self.title=title
		self.description=description
		self.date=date
	}
	init() {self.id = "\(UUID())"}
}
class ReviewViewModel: MyViewModel<Review>{
	
	var baseReviewReference: DatabaseReference{
		return Database.database().reference().child("reviews")
	}
	//user, userid, prof, profid must all be set before this is called!
	override func publishNewModel(customID: String? = nil) async -> Bool {
		do{
			//publish the review
			guard await super.publishNewModel(customID: customID) else{return false}
			//assign it to the professor
			let profRef = ReviewListViewModel.baseProfessorReviewsReference.child(model.teacherID)
			try await profRef.updateChildValues([model.id: 0])
			//assign it to the user
			let userRef = Database.database().reference().child("users-reviews").child(model.authorID)
			try await userRef.updateChildValues([model.id: 0])
			return true
		}catch{
			UserVM.currentUser.showAlertMessage(message: "Σφάλμα αποθήκευσης. Δοκιμάστε ξανά αργότερα. (\(error)")
			return false
		}
	}
}
