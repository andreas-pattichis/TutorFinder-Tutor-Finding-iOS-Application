
import Foundation
import Firebase
import SwiftUI
import Combine
struct ProfessorsCourses: StorableOnFirebase, DictionaryCodable{
	var id:String  = "\(UUID())"
	var courseIDs = [String]()
	static var genericName: String = "Ακροατήρια Εκπαιδευτικού"
	static var basePathString: String = "professors-courses"
	
	func toDict() -> [String : Any] {
		return [
			"courseIDs":courseIDs
		]
	}
	init(){}
	init?(id: String, dict: [String : Any]) {
		self.id=id
		guard let courses = dict["courseIDs"] as? [String] else {return nil}
		self.courseIDs=courses
	}
}
class ProfessorCoursesVM: MyViewModel<ProfessorsCourses>{
	static var current = ProfessorCoursesVM()
	static func loggedIn(profID: String){
		current.observeModel(id: profID)
	}
	static func loggedOut(){
		current = ProfessorCoursesVM()
	}
	static func addCourseToProfessor(courseID: String, professorID: String)async -> Bool{
		do{
			var currentProfessorsCoursesModel: ProfessorsCourses?
			currentProfessorsCoursesModel = try await getModel(id: professorID)
			if  currentProfessorsCoursesModel == nil {
				currentProfessorsCoursesModel = ProfessorsCourses()
				currentProfessorsCoursesModel!.id = professorID
			}
			currentProfessorsCoursesModel!.courseIDs.append(courseID)
			let vm = ProfessorCoursesVM(model: currentProfessorsCoursesModel!)
			return await vm.updateModel()
		}catch{
			UserVM.currentUser.showAlertMessage(message: "Σφάλμα δημιουργώντας ακροατήριο. Παρακαλώ δοκιμάστε ξανά αργότερα. (\(error))")
			return false
		}
	}
	
}
class CourseListViewModel: MyListViewModel<Course, CourseViewModel>{
	static var allCourses = CourseListViewModel()
	static var currentUsersCourses = CourseListViewModel()
	func observeStudentsCourses(studentID: String){
		let courseRegisters = CourseRegisterListViewModel.currentUsersRegisters
		let sub = courseRegisters.objectWillChange.sink{[weak self] in
			print("[CourseListVM new]: Registers of student \(studentID) changed")
			let newIDs = courseRegisters.models.map{$0.model.courseID}
			self?.makeSureOnlyTheseIDsAreObserved(ids: newIDs)
		}
		self.anys["studentsCourses-\(studentID)"]=sub
	}
	func observeProfessorsCourses(professorID: String){
		let professorsCoursesList = ProfessorCoursesVM.current
		let sub = professorsCoursesList.objectWillChange.sink{[weak self] in
			print("[CourseListVM]: Registers of professor \(professorID) changed")
			print("[PROF COURSES] Will observe courses \(professorsCoursesList.model.courseIDs.joined(separator: ","))")
			let currentIDs = professorsCoursesList.model.courseIDs
			self?.makeSureOnlyTheseIDsAreObserved(ids: currentIDs)
		}
		self.anys["professorsCourses-\(professorID)"]=sub
	}
	func observeUsersCourses(user: UserVM, userID: String){
		switch user.model.userType{
		case .student:
			observeStudentsCourses(studentID: userID)
			break
		case .teacher:
			observeFilteredByProperty(propertyName: "teacherID", equalTo: userID)
//			observeProfessorsCourses(professorID: userID)
		}
	}
	static func observeCurrentUsersCourses(userID: String){
		currentUsersCourses.observeUsersCourses(user: UserVM.currentUser, userID: userID)
	}
	static func initialize(){
		allCourses.observeAll()
	}
	static func loggedOut(){
		currentUsersCourses = CourseListViewModel()
	}
}
