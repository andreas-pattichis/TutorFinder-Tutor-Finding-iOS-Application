//
//  GradeListVM.swift
//  TutorFind
//
//  Created by Leonidas Lampiritis on 30/11/2021.
//

import Foundation
import Combine
class GradeListVM: MyListViewModel<Grade, GradeViewModel>{
	static let currentUsersGrades = GradeListVM()

	static func userChanged(){
		currentUsersGrades.removeAllObservers()
		let user = UserVM.currentUser
		guard let userID = user.getUserIDIfLoggedInOrShowMessageAndLogoutIfNot() else{return}
		switch user.model.userType{
		case .student:
			currentUsersGrades.observeStudentsGrades(studentID: userID)
		case .teacher:
			currentUsersGrades.observeProfessorsGrades(professorID: userID)
		}
	}
	func observeStudentsGrades(studentID: String){
		observeFilteredByProperty(propertyName: "studentID", equalTo: studentID)
	}
	func observeProfessorsGrades(professorID: String){
		observeFilteredByProperty(propertyName: "professorID", equalTo: professorID)
	}
}
