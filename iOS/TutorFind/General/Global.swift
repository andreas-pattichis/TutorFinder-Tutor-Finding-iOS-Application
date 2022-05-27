//
//  Global.swift
//  TutorFinder
//
//  Created by Andreas Loizides on 28/11/2021.
//

import Foundation
import Combine
class GlobalConfigurator{
	static let main = GlobalConfigurator()
	private init(){}
	private(set) var configuredForCurrentUser=false
	private(set) var storedUserID=""
	func initialize(){
		print("[GlobalConfigurator]: Initializing")
		CourseListViewModel.initialize()
	}
	func userInfoChanged(user: UserVM, userID: String){
		guard !configuredForCurrentUser && userID != storedUserID else{return}
		loggedOut()
		print("[GlobalConfigurator]: User changed")
		GradeListVM.userChanged()
		CourseListViewModel.observeCurrentUsersCourses(userID: userID)
		switch user.model.userType{
		case .student:
			CourseRegisterListViewModel.observeStudentsCourses(studentID: userID)
			print("[GlobalConfigurator]: Now observing student \(userID)'s course IDs")
		case .teacher:
			Professor.current.loadModel(userID: userID)
			ProfessorCoursesVM.loggedIn(profID: userID)
			UserListVM.professorsStudents.observeStudentsOfProfessor(professorID: userID)
			print("[GlobalConfigurator]: \tNow observing professor \(userID)")
			
		}
		print("[GlobalConfigurator]: Now observing courses of user \(userID)")
		configuredForCurrentUser=true
		storedUserID=userID
	}
	func loggedOut(){
		print("[GlobalConfigurator]: User logged out. Removing all observers.")
		self.configuredForCurrentUser=false
		self.storedUserID=""
		CourseListViewModel.loggedOut()
		CourseRegisterListViewModel.loggedOut()
		ProfessorCoursesVM.loggedOut()
		UserListVM.loggedOut()
		Professor.current.signOut()
	}
	
}
