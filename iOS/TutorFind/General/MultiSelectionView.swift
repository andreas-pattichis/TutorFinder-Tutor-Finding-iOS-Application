//
//  View for multiselection, created by Andreas Pattichis
//

import SwiftUI
extension Array where Element == Day{
	mutating func sortDaysChronologically(){
		sort{
			$0.dayInWeekStartingAtZeroOfCourse() < $1.dayInWeekStartingAtZeroOfCourse()
		}
	}
}
extension Identifiable{
	var idString: String{
		if let str = self as? String{
			return str
		}else{
			return "\(self)"
		}
	}
}

struct MultiSelectionView<Selectable: Identifiable & Hashable>: View {
	let options: [Selectable]
	
	@Binding var selected: [Selectable]
	
	var body: some View {
		List {
			ForEach(options) { selectable in
				Button(action: { toggleSelection(selectable: selectable) }) {
					HStack {
						Text(selectable.idString).foregroundColor(Color.black)
						Spacer()
						if selected.contains(selectable) {
							Image(systemName: "checkmark")
							//								.foregroundColor(.accentColor)
						}
					}
				}.tag(selectable.idString)
			}
		}.listStyle(GroupedListStyle())
	}
	
	private func toggleSelection(selectable: Selectable) {
		if let index = selected.firstIndex(of: selectable){
			selected.remove(at: index)
		}else{
			selected.append(selectable)
		}
		selected.sort{
			if let day0 = $0 as? Day
				,let day1 = $1 as? Day{
				return day0.dayInWeekStartingAtZeroOfCourse() < day1.dayInWeekStartingAtZeroOfCourse()
			}else{
				return $0.idString<$1.idString
			}
		}
	}
}

struct MultiSelectionView_Previews: PreviewProvider {
	
	@State static var selected = ["do"]
	
	static var previews: some View {
		NavigationView {
			MultiSelectionView(
				options: ["do", "re", "mi", "fa"],
				selected: $selected
			)
		}
	}
}
