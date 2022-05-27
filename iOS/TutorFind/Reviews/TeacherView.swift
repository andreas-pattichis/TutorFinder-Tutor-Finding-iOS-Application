//
//  View to display the teacher's details, created by Andreas Pattichis
//

import SwiftUI



struct TeacherView: View {
	let teacherID: String
	var isContained: Bool = false
	@ObservedObject var reviewList: ReviewListViewModel
	@StateObject var professor = UserVM()
	@State private var newReviewIsShown = false
    var body: some View {
        let stack = VStack{
			Text(isContained ? "Κριτικές" : professor.model.fullName)
				.onAppear{
					professor.loadAndObserveInfo(ofUserID: teacherID)
				}
			Spacer()
			if reviewList.models.isEmpty{
				Text("Δεν υπάρχουν κριτικές")
			}else{
				List(reviewList.models, id: \.id){rev in
                VStack{
					NavigationLink(destination: {
						ReviewDetailView(review: rev)
					}, label: {
						HStack{
							Text(rev.model.title)
							.bold()
							Spacer()
							StarsView(rating: rev.model.grade)
						}
					})
                }
			}
            }
			Spacer()
				
        }
		if isContained{
			stack
		}else{
			stack
			.navigationTitle("Κριτικές")
			.toolbar{
			ToolbarItemGroup(placement: .primaryAction){
				if UserVM.currentUser.model.userType == .student{
				Button("Δημιουργία"){
					newReviewIsShown=true
				}
				}
			}
		}
			.sheet(isPresented: $newReviewIsShown, onDismiss: nil){
				NavigationView{
			NewReviewView(isShown: $newReviewIsShown, userID: UserVM.currentUser.getUserID() ?? "", userName: UserVM.currentUser.model.fullName, teacherID: teacherID, teacherName: professor.model.fullName)
				}
		}
		}
    }
}

struct TeacherView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView{
			TeacherView(teacherID: "MMnvOTLY11f4hzghnXkmSmke4My2", reviewList: .ofProfessor(id: "MMnvOTLY11f4hzghnXkmSmke4My2"))
		}
    }
}
