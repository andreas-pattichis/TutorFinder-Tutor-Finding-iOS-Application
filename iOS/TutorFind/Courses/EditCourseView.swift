//
//  EditCourseView.swift
//  TutorFind
//
//  Created by Andreas Loizides on 02/12/2021.
//

import SwiftUI

struct EditCourseView: View {
	@ObservedObject var courseVM: CourseViewModel
	@State private var endTime = Date().addingTimeInterval(90*60)
	@State private var submitButtonDisabled=false
	@Binding var isShown: Bool
	var body: some View {
			Form{
				Section("ΟΝΟΜΑ ΜΑΘΗΜΑΤΟΣ"){
					TextField("πχ Μαθηματικά", text: $courseVM.model.title, prompt: nil)
				}
				.onAppear{
					endTime = courseVM.model.startTime.addingTimeInterval(Double(courseVM.model.lengthInMinutes*60))
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
			
			.navigationTitle(courseVM.model.title)
				.toolbar{
					Button("Submit", action: updateCourse)
						.disabled(submitButtonDisabled)
				}
				.foregroundColor(courseVM.model.color)
	}
	func getDurationInMinutes()->Int{
		let duration = Calendar.current.dateComponents([.minute], from: courseVM.model.startTime, to: endTime).minute!
		return duration
	}
	func updateCourse(){
		courseVM.model.lengthInMinutes=Calendar.current.dateComponents([.minute], from: courseVM.model.startTime, to: endTime).minute!
		Task{
			DispatchQueue.main.async {
				submitButtonDisabled=true
			}
			if await courseVM.updateModel(){
				isShown=false
			}
			DispatchQueue.main.async {
				submitButtonDisabled=false
			}
		}
	}
}

struct EditCourseView_Previews: PreviewProvider {
    static var previews: some View {
		EditCourseView(courseVM: CourseViewModel(), isShown: .constant(true))
    }
}
