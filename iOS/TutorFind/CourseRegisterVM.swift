//
//  CourseRegisterVM.swift
//  TutorFind
//
//  Created by Andreas Loizides on 28/11/2021.
//

import Foundation
import Firebase
import SwiftUI
import Combine

class CourseRegistersViewModel: MyViewModel<CourseRegister>{
	func registerToCourse(studentID: String, courseVM: CourseViewModel)async->Bool{
		model.professorID=courseVM.model.teacherID
		model.studentID=studentID
		model.courseID=courseVM.model.id
		model.date=Date()
		return await super.publishNewModel()
	}
}
class CourseRegisterListViewModel: MyListViewModel<CourseRegister, CourseRegistersViewModel>{
	typealias W = CourseRegistersViewModel
	func observeRegistersOfTeacher(withID: String){
		observeFilteredByProperty(propertyName: "professorID", equalTo: withID)
	}
	func observeRegistersOfStudent(withID: String){
		observeFilteredByProperty(propertyName: "studentID", equalTo: withID)
	}
	func observeRegistersOfCourse(withID: String){
		observeFilteredByProperty(propertyName: "courseID", equalTo: withID)
	}
	
	
	static var currentUsersRegisters = CourseRegisterListViewModel()
//	func getRegistration(forCourseID courseID: String)->CourseRegistersViewModel?{
//		if let reg = models.first(where: {$0.model.courseID == courseID}){
//			return reg
//		}
//	}
	static func observeStudentsCourses(studentID: String){
		currentUsersRegisters.observeRegistersOfStudent(withID: studentID)
	}
	static func loggedOut(){
		currentUsersRegisters = CourseRegisterListViewModel()
	}
}
