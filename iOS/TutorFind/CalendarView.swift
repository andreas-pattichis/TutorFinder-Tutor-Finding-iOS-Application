//
//  CalendarView.swift
//  TutorFind
//
//  Created by Andreas Loizides on 02/12/2021.
//

import SwiftUI
extension Array where Element == CourseViewModel{
	func sortedByDate(inDay day: Day)->Self{
		return filter{d in
			return d.model.frequency.contains(where: {$0 == day})
		}.sorted(by: {d0, d1 in
			d0.model.startTime < d1.model.startTime
		})
	}
}
extension Array where Element == Course{
	func sortedByDate(inDay day: Day)->Self{
		return filter{d in
			return d.frequency.contains(where: {$0 == day})
		}.sorted(by: {d0, d1 in
			d0.startTime < d1.startTime
		})
	}
}
struct CalendarView: View {
	@ObservedObject var courses = CourseListViewModel.currentUsersCourses
	@State private var dayExpanded = Day.allCases.reduce(into: [Day: Bool](), {$0[$1]=true})
    var body: some View {
		List{
		ForEach(Day.allCases, id: \.self){day in
			//In a given day find which of my courses I have
			DisclosureGroup(day.rawValue, isExpanded: Binding(get: {dayExpanded[day]!}, set: {dayExpanded[day]=$0})){
				//Sort the by time
				ForEach(courses.models.sortedByDate(inDay: day)){vm in
					NavigationLink(destination: {
						CourseDetailView(courseVM: vm)
					}, label: {
						CourseCellView(displayTime: true, courseVM: vm)
					})
				}
			}
		}
		.navigationBarTitle("Εβδομάδα")
		}
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
