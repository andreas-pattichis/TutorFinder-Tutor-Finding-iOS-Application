//
//  View to create a new review for a teacher, created by Andreas Pattichis.
//

import SwiftUI

struct NewReviewView: View {
	@StateObject var review = ReviewViewModel()
	
	@Binding var isShown: Bool
	
	let userID: String
	let userName: String
	let teacherID: String
	let teacherName: String
	
    var body: some View {
			VStack {
				Form{
					TextField("Τίτλος", text: $review.model.title)
					TextField("Περιεχόμενο", text: $review.model.description)
					HStack{
						StarsView(rating: review.model.grade)
						Stepper("", onIncrement: {
							guard review.model.grade<5 else{return}
							withAnimation{
								review.model.grade+=0.5
							}
						} , onDecrement: {
							guard review.model.grade>0 else{return}
							withAnimation{
								review.model.grade-=0.5
							}
						} )
					}
				}
				
				Text("Καθηγήτρια/ής")
					.font(.footnote)
				Text(teacherName)
			.navigationTitle("Νεα Κριτική")
			.toolbar{
				ToolbarItemGroup(placement: .primaryAction){
					Button("Καταχώριση"){
						review.model.author=userName
						review.model.authorID=userID
						review.model.teacherName=teacherName
						review.model.teacherID=teacherID
						Task{
							if await review.publishNewModel(){
								DispatchQueue.main.async {
									self.isShown=false
								}
							}
							
						}
					}
				}
			}
			}
//		}
    }
}

struct NewReviewView_Previews: PreviewProvider {
    static var previews: some View {
		NewReviewView(isShown: .constant(true), userID: "", userName: "user", teacherID: "", teacherName: "teacher")
    }
}
