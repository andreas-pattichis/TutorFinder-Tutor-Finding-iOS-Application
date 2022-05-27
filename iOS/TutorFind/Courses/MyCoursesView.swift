import SwiftUI

extension CourseListViewModel{
	func applyingFilters(taksi: Taksi, schoolType: SchoolType, classType: ClassType, searchText: String)->[CourseViewModel]{
		return self.models.filter{courseVM in
			let course = courseVM.model
			if taksi != .any{
				guard course.taksi == taksi else{return false}
			}
			if schoolType != .any{
				guard course.schoolType == schoolType else {return false}
			}
			if classType != .dontCare{
				guard course.classType == classType else {return false}
			}
			guard searchText == "" || searchText == " " else{
				return course.title.contains(searchText)
			}
			return true
		}
	}
}

struct MyCoursesView: View {
	@ObservedObject var user = UserVM.currentUser
	@State private var showingSearch = false
	@State private var showingFilters = false
	
	@State private var taksi: Taksi = .any
	@State private var schoolType: SchoolType = .any
	@State private var classType: ClassType = .dontCare
	@State private var filtersAreExpanded: Bool = false
	@State private var searchText = ""
	@ObservedObject var courses = CourseListViewModel.currentUsersCourses
	var body: some View {
		VStack{
			List{
					SearchBarView(searchText: $searchText)
					Section{
						DisclosureGroup("Φίλτρα", isExpanded: $filtersAreExpanded) {
							FilterSelectionView(selectedValue: $taksi, label: "Τάξη")
							FilterSelectionView(selectedValue: $schoolType, label: "Επίπεδο")
							FilterSelectionView(selectedValue: $classType, label: "Μάθημα")
					}
				}
				ForEach(courses.applyingFilters(taksi: taksi, schoolType: schoolType, classType: classType, searchText: searchText), id: \.model.id){courseVM in
					NavigationLink(destination: CourseDetailView(courseVM: courseVM), label: {CourseCellView(courseVM: courseVM)})
				}
			}}
		.navigationTitle("Τα μαθήματά μου")
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView{
			MyCoursesView()
		}
	}
	
}

