//
//  SearchView.swift
//  TudorFind
//
//  Created by Leonidas Lampiritis on 27/11/2021.
//

import SwiftUI
//Simple view to display a picker for any enum type (that is case iterable obviously)
struct FilterSelectionView<E: RawRepresentable & CaseIterable & Hashable & Identifiable>: View where E.RawValue == String{
	@Binding var selectedValue: E
	let label: String
	var excluding: [E]? = nil
	var body: some View{
		HStack{
			Text(label)
			Spacer()
			Picker(label, selection: $selectedValue){
				ForEach(Array(E.allCases).filter{
					guard let excluding = excluding else{
						return true
					}
					return !excluding.contains($0)
				}, id:\.self){pref in
					Text(pref.rawValue)
				}
			}.pickerStyle(.menu)
		}
	}
}
enum Taksi: String, Identifiable, CaseIterable, Codable{
	var id: String {return self.rawValue}

	case any = "Οποιαδήποτε"
	case a = "Α'"
	case b = "Β'"
	case g = "Γ'"
}
enum SchoolType: String, Identifiable, CaseIterable, Codable{
	var id: String {return self.rawValue}

	case any = "Οποιοδήποτε"
	case gymnasio = "Γυμνασίου"
	case lykeio = "Λυκείου"
}
enum ClassType: String, Identifiable, CaseIterable, Codable{
	var id: String {return self.rawValue}

	case dontCare = "Οποιοδήποτε"
	case biology = "Βιολογία"
	case nea = "Νέα Ελληνικά"
	case math = "Μαθηματικά"
	case archaia = "Αρχαία"
	case fysiki = "Φυσική"
	case cs = "Πληροφορική"
}
struct SearchView: View {

	@State private var taksi: Taksi = .any
	@State private var schoolType: SchoolType = .any
	@State private var classType: ClassType = .dontCare
	@State private var filtersAreExpanded: Bool = true
	@State private var searchText = ""
	@ObservedObject var courses = CourseListViewModel.allCourses
    var body: some View {
			VStack{
				SearchBarView(searchText: $searchText)
				Section{
					DisclosureGroup("Φίλτρα", isExpanded: $filtersAreExpanded) {
						FilterSelectionView(selectedValue: $taksi, label: "Τάξη")
						FilterSelectionView(selectedValue: $schoolType, label: "Επίπεδο")
						FilterSelectionView(selectedValue: $classType, label: "Μάθημα")

					}
				}
				List{
					ForEach(courses.models.applyingFilters(taksi: taksi, schoolType: schoolType, classType: classType, searchText: searchText), id: \.model.id){course in
					NavigationLink(destination: {CourseDetailView(courseVM: course)}, label: {CourseCellView(courseVM: course)})
				}
				}
				.padding(.top, 20)
				Spacer()
			}
			.padding()
			.navigationTitle("Search")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
		SearchView()
    }
}
