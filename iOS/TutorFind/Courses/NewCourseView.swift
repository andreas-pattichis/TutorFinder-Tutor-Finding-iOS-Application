import SwiftUI
struct OptionsContainer<E: RawRepresentable & CaseIterable & Hashable & Identifiable>: View where E.RawValue == String{
	var selectedOptions = [E]()
	var body: some View{
		ForEach(Array(E.allCases)){e in
			Text(e.rawValue)
		}
	}
}
@available(iOS 15.0, *)
struct NewCourseView: View {
	@StateObject var courseVM = CourseViewModel()
	@State private var endTime = Date().addingTimeInterval(90*60)
	@State private var submitButtonDisabled=false
	var body: some View {
			Form{
				Section("ΟΝΟΜΑ ΜΑΘΗΜΑΤΟΣ"){
					TextField("πχ Μαθηματικά", text: $courseVM.model.title, prompt: nil)
				}
				FilterSelectionView(selectedValue: $courseVM.model.taksi, label: "Τάξη", excluding: [.any])
				FilterSelectionView(selectedValue: $courseVM.model.schoolType, label: "Επίπεδο", excluding: [.any])
				FilterSelectionView(selectedValue: $courseVM.model.classType, label: "Μάθημα", excluding: [.dontCare])
				HStack{
					Text("Χρώμα")
					Spacer()
					ColorPicker("", selection: $courseVM.model.color)
				}
				Section("ΧΡΟΝΟΣ"){
					DatePicker("Ξεκινά", selection: $courseVM.model.startTime, displayedComponents: [.hourAndMinute])
					DatePicker("Τελειώνει (\(getDurationInMinutes()) λεπτά)", selection: $endTime, displayedComponents: [.hourAndMinute])
					NavigationLink(destination: {
						MultiSelectionView(options: Day.allCases, selected: $courseVM.model.frequency)
					}, label: {
						Label(Array(courseVM.model.frequency).map{
							courseVM.model.frequency.count > 2 ?
							$0.getPrefix()
							:
							$0.rawValue
						}.joined(separator: ","), systemImage: "calendar")
					})
				}
			}
			
		.navigationTitle("Νεο ακροατήριο")
				.toolbar{
					Button("Submit", action: registerNewCourse)
						.disabled(submitButtonDisabled)
				}
				.foregroundColor(courseVM.model.color)
	}
	func getDurationInMinutes()->Int{
		let duration = Calendar.current.dateComponents([.minute], from: courseVM.model.startTime, to: endTime).minute!
		return duration
	}
	func registerNewCourse(){
		courseVM.model.lengthInMinutes=Calendar.current.dateComponents([.minute], from: courseVM.model.startTime, to: endTime).minute!
		Task{
			DispatchQueue.main.async {
				submitButtonDisabled=true
			}
			let _ = await courseVM.publishNewModel()
			DispatchQueue.main.async {
				submitButtonDisabled=false
			}
		}
	}
}

@available(iOS 15.0, *)
struct NewCourseView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView{
			NewCourseView()
		}
	}
}
