import Foundation
import Combine
class UserListVM: MyListViewModel<User, UserVM>{
	static var professorsStudents = UserListVM()
	var studentsRegisters: CourseRegisterListViewModel?
	func observeStudentsOfProfessor(professorID: String){
		self.studentsRegisters = CourseRegisterListViewModel()
		let a = studentsRegisters!.objectWillChange.sink{[weak self] in
			guard let self=self else{return}
			let modelvms = self.models
			let models = modelvms.map{$0.model}
			let studentIDs = Set(self.studentsRegisters!.models.map{$0.model.studentID})
			//set to avoid duplicates; a student may be registered to more than one courses of the same professor
			self.makeSureOnlyTheseIDsAreObserved(ids: Array(studentIDs))
		}
		studentsRegisters!.observeRegistersOfTeacher(withID: professorID)
		self.anys["studentsOfProfessor"]=a
	}
	static func loggedOut(){
		professorsStudents = UserListVM()
	}
}
