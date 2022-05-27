import SwiftUI

struct EditGradeView: View {
	@ObservedObject var gradeVM: GradeViewModel
	@Binding var editIsShown: Bool
	@State private var submitButtonDisabled = false
	var body: some View {
//		NavigationView{
			List{
				if UserVM.currentUser.model.userType == .teacher{
					HStack{
						Text("Μαθητής")
							.bold()
						Spacer()
						Text(gradeVM.model.studentName)
					}
				}else{
					HStack{
						Text("Καθηγητής")
							.bold()
						Spacer()
						Text(gradeVM.model.professorName)
					}
				}
				HStack{
					Text("Βαθμός")
						.bold()
					Spacer()
					TextField("", text: $gradeVM.model.grade)
				}
				HStack{
					Text("Ημερομηνία")
						.bold()
					Spacer()
					Text(gradeVM.model.date.toGreekString())
				}
				VStack{
					HStack{
						Text("Σχόλια")
							.bold()
						Spacer()
						
					}.padding(.bottom,10)
					TextField("", text: $gradeVM.model.comments)
						.fixedSize(horizontal: false, vertical: true)
					.font(.body)
					
				}
				Spacer()
				
			}
			.navigationTitle(gradeVM.model.title)
			.toolbar{
				ToolbarItemGroup(placement: .primaryAction){
					Button("Καταχώριση"){
						self.submitButtonDisabled=true
						Task{
							if await self.gradeVM.updateModel(){
								self.editIsShown = false
							}
							self.submitButtonDisabled=false
						}
					}
					.disabled(submitButtonDisabled)
				}
			}
//		}
	}
}

struct EditGradeView_Previews: PreviewProvider {
	static var previews: some View {
		EditGradeView(gradeVM: GradeViewModel(), editIsShown: .constant(true))
	}
}
