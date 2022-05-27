import SwiftUI

struct GradeDetailView: View {
	@ObservedObject var gradeVM: GradeViewModel
	@State private var editIsShown = false
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
						NavigationLink(destination: {
							TeacherView(teacherID: gradeVM.model.professorID, reviewList: .ofProfessor(id: gradeVM.model.professorID))
						}, label: {
							Text("Καθηγητής")
								.bold()
						})
						Spacer()
						Text(gradeVM.model.professorName)
					}
				}
				HStack{
					Text("Βαθμός")
						.bold()
					Spacer()
					Text(gradeVM.model.grade)
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
					Text(gradeVM.model.comments)
						.fixedSize(horizontal: false, vertical: true)
					.font(.body)
					
				}
				Spacer()
				
			}
			.navigationTitle(gradeVM.model.title)
			.toolbar{
				ToolbarItemGroup(placement: .primaryAction){
					if UserVM.currentUser.model.userType == .teacher{
					Button("Επεξεργασία"){
						self.editIsShown=true
					}
					}
				}
			}
			.sheet(isPresented: $editIsShown, onDismiss: nil){
				NavigationView{
					EditGradeView(gradeVM: self.gradeVM, editIsShown: $editIsShown)
				}
			}
//		}
    }
}

struct GradeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GradeDetailView(gradeVM: GradeViewModel())
    }
}
