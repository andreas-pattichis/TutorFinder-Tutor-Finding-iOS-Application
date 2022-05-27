import SwiftUI
import Firebase
import Combine
extension Course{
	func timelyDescription()->String{
		let endTime = startTime.addingTimeInterval(Double(self.lengthInMinutes*60))
		let startString = startTime.minuteAndHourString()
		let endString = endTime.minuteAndHourString()
		return "\(title) \(startString)-\(endString)"
	}
}
struct EnterGradeView: View {
	@Binding var isShown: Bool
	@ObservedObject var myCourses = CourseListViewModel.currentUsersCourses
	@ObservedObject private var professorsStudents = UserListVM.professorsStudents
	@StateObject private var gradeVM = GradeViewModel()
	@State private var selectedCourse = CourseListViewModel.currentUsersCourses.models.map{$0.model}.first ?? Course()
	@State private var selectedStudent = UserListVM.professorsStudents.models.map{$0.model}.first ?? User()
    var body: some View {
		//Vstack to print vertically
			VStack{
				CustomFilterSelectionView<Course>(selectedValue: $selectedCourse, label: "Ακροατήριο", allValues: myCourses.models.map{$0.model}, labelFunction: {$0.timelyDescription()})
				CustomFilterSelectionView<User>(selectedValue: $selectedStudent, label: "Παραλήπτης", allValues: professorsStudents.models.map{$0.model}
													.filter{student in
					guard let registrations = self.professorsStudents.studentsRegisters else{return false}
					return registrations.models.contains(where: {
						let selectedCourseID = self.selectedCourse.id
						let examinedStudentID = $0.model.studentID
						let examinedCoruseID = $0.model.courseID
						return examinedStudentID == student.id
						&&
						examinedCoruseID == selectedCourseID
					})
				}
												, labelFunction: {$0.fullName})
				
				TextField("Τίτλος", text: $gradeVM.model.title)
					.textFieldStyle(.roundedBorder)
				TextField("Βαθμός", text: $gradeVM.model.grade)
					.textFieldStyle(.roundedBorder)
				HStack{Text("Σχόλια");Spacer()}
				.padding(.top, 20)
				TextField("", text: $gradeVM.model.comments)
					.frame(height: 200)
						.textFieldStyle(PlainTextFieldStyle())
						.padding([.horizontal], 4)
						.cornerRadius(16)
						.overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
			Spacer()
					Button("Καταχώρηση", action: publish)
					.buttonStyle(GrowingButton())
				}
			.padding()
			.navigationTitle("Καταχώρηση Βαθμού")
    }
	func publish(){
		//VALIDATION HERE!
		guard let professorID = UserVM.currentUser.getUserIDIfLoggedInOrShowMessageAndLogoutIfNot() else{return}
		gradeVM.model.professorID=professorID
		gradeVM.model.professorName = UserVM.currentUser.model.fullName
		
		gradeVM.model.courseName=selectedCourse.title
		gradeVM.model.courseID=selectedCourse.id
		
		gradeVM.model.studentID=selectedStudent.id
		gradeVM.model.studentName=selectedStudent.fullName
		
		gradeVM.model.date=Date()
		
		Task{
			if await gradeVM.publishNewModel(){
				self.isShown=false
			}
		}
	}
}

struct EnterGradeView_Previews: PreviewProvider {
    static var previews: some View {
		EnterGradeView(isShown: .constant(true))
    }
}
