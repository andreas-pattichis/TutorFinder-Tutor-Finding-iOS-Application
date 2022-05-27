import SwiftUI
import MapKit
import Combine

struct CourseDetailView: View {

	@ObservedObject var courseVM: CourseViewModel
	@ObservedObject var professor = Professor(modelName: "prof")
	@ObservedObject var registrations = CourseRegisterListViewModel.currentUsersRegisters
	@State private var registration: CourseRegistersViewModel?
	@State private var registrationInProgress=false
	@ObservedObject var user = UserVM.currentUser
	@State private var any: AnyCancellable?
	@State private var editIsShown = false
	@ObservedObject var myStudents = UserListVM.professorsStudents
	var body: some View {
		let stack =
		VStack(alignment: .leading){
			Label("Κάθε \(courseVM.model.frequency.map{$0.rawValue}.joined(separator: ","))", systemImage: "calendar")
				.padding(.leading, 20)
				.navigationTitle(courseVM.model.title)
				.onAppear{
					professor.loadModel(userID: courseVM.model.teacherID)
					checkIsRegistered()
					self.any = registrations.objectWillChange.sink{
						checkIsRegistered()
					}
				}
			NavigationLink(destination: {TeacherView(teacherID: courseVM.model.teacherID, reviewList: .ofProfessor(id: courseVM.model.teacherID))}, label: {Label("Teacher: \(courseVM.model.teacherName)", systemImage: "person.fill")})
				.padding(.leading, 20)
			Label("Αρχίζει στις \(courseVM.model.startTime.minuteAndHourString())", systemImage: "calendar.day.timeline.left")
				.padding(.leading, 20)
			Label("Διάρκεια: \(courseVM.model.lengthInMinutes) λεπτά", systemImage: "clock")
				.padding(.leading, 20)
			Label("Διεύθυνση: \(professor.address)", systemImage: "location.circle.fill")
				.padding(.leading, 20)
			
			SimpleMapView(longitude: professor.longitude, latitude: professor.latitude)
			Divider()
			if user.model.userType == .student{
				if registration != nil && !registrationInProgress{
					VStack{HStack{
						Text("Amount due:")
							.font(.title2)
						Spacer()
						Text("€0")
							.font(.title2)
					}
					.padding(.horizontal, 20)
						Button("Pay"){
							
						}
						.buttonStyle(GrowingButton(isDisabled: true))
					}
				}else{
					HStack{
						Spacer()
						Button("Εγγραφή"){
							guard let userID = user.getUserIDIfLoggedInOrShowMessageAndLogoutIfNot() else{return}
							registrationInProgress=true
							self.registration = CourseRegistersViewModel()
							Task{
								let _ = await registration!.registerToCourse(studentID: userID, courseVM: courseVM)
								DispatchQueue.main.async {
									withAnimation{
										registrationInProgress=false
									}
								}
							}
					}
					.buttonStyle(GrowingButton(isDisabled: registrationInProgress))
						Spacer()
					}
				}
				
			}
			else{
				Text("Εγγεγραμμένοι")
					.font(.title2)
					.padding(.horizontal, 20)
				List{
					ForEach(myStudents.models.filter{st in
						return
						
						myStudents.studentsRegisters!.models.contains(where: {reg in
							reg.model.studentID == st.model.id
							&&
							reg.model.courseID
							== courseVM.model.id
						})
					}, id: \.id){u in
						NavigationLink(destination: {
							UserView(user: u, prof: Professor.current)
						}, label: {
							Text(u.model.fullName)
						})
					}
				}
				Spacer()
			}
		}
		if user.model.userType == .teacher && courseVM.model.teacherID == user.getUserID()!{
			stack
				.sheet(isPresented: $editIsShown, onDismiss: nil){
					NavigationView{
						EditCourseView(courseVM: courseVM, isShown: $editIsShown)
					}
				}
				.toolbar{
					ToolbarItemGroup(placement: .primaryAction){
						Button("Επεξεργασία"){
							editIsShown=true
						}
					}
				}
		}else{
			stack
		}
	}
	func checkIsRegistered(){
		let courseID = courseVM.model.id
		if let registrationThatExists = registrations.models.first(where: {$0.model.courseID == courseID}){
			self.registration=registrationThatExists
		}
	}
}

struct CourseDetailView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView{
		CourseDetailView(courseVM: CourseViewModel(model: Course.data[0]))
		}
	}
}
