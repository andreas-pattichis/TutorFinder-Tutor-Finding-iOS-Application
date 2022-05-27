//
//  CustomFilterSelectionView.swift
//  TutorFind
//
//  Created by Andreas Loizides on 30/11/2021.
//

import SwiftUI
struct CustomFilterSelectionView<T: Hashable & Identifiable>: View {
	@Binding var selectedValue: T
	let label: String
	let allValues: [T]
	var excluding: [T]? = nil
	let labelFunction: (T)->String
	var body: some View{
		HStack{
			Text(label)
			Spacer()
			Picker(label, selection: $selectedValue){
				ForEach(allValues.filter{
					guard let excluding = excluding else{
						return true
					}
					return !excluding.contains($0)
				}, id:\.self){pref in
					Text(labelFunction(pref))
				}
			}.pickerStyle(.menu)
		}
	}
}


struct CustomFilterSelectionView_Previews: PreviewProvider {
	static let courses = Course.data
    static var previews: some View {
		CustomFilterSelectionView(selectedValue: .constant(courses[0]), label: "h", allValues: courses, labelFunction: {$0.title})
    }
}
