//
//  GradesView.swift
//  EduFind
//
//  Created by Andreas Loizides on 24/10/2021.
//

import SwiftUI

struct GradeRowView: View{
	let grade: Grade
	var body: some View{
		HStack{
			Text(grade.title)
			Spacer()
			Text(grade.grade)
		}
	}
}
@available(iOS 15.0, *)
struct GradesView: View {
	@ObservedObject var courses = CourseListViewModel.currentUsersCourses
	@ObservedObject var grades = GradeListVM.currentUsersGrades
	@State private var showingNewGradeView = false
	var body: some View {
		VStack{
			List{
				ForEach(courses.models.map{$0.model}, id: \.id){course in
					Section(course.title){
						ForEach(grades.models.filter({$0.model.courseID == course.id})){gradeVM in
							NavigationLink(destination: {
								GradeDetailView(gradeVM: gradeVM)
							}, label: {
								GradeRowView(grade: gradeVM.model)
							})
						}
					}
				}
			}
		}
		.navigationTitle("Βαθμολογίες")
		.toolbar{
			ToolbarItemGroup(placement: .primaryAction){
				if UserVM.currentUser.model.userType == .teacher{
					Button("Νέα"){
						showingNewGradeView=true
					}
				}
			}
		}
		.sheet(isPresented: $showingNewGradeView){
			NavigationView{
				EnterGradeView(isShown: $showingNewGradeView)
			}
		}
	}
}

@available(iOS 15.0, *)
struct GradesView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView{
			GradesView()
		}
	}
}
