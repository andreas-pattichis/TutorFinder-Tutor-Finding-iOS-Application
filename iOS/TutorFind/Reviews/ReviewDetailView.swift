//
//  View to display the details of the review, created by ANdreas Pattichis
//
import SwiftUI

struct ReviewDetailView: View {
	@ObservedObject var review: ReviewViewModel
	@State private var editViewShown = false
    var body: some View {
		let stack =
		VStack(alignment: .leading){
			Text(review.model.title)
				.font(.title)
				.sheet(isPresented: $editViewShown, onDismiss: nil){
					NavigationView{
						EditReviewView(review: review, isShown: $editViewShown, teacherName: review.model.teacherName)
					}
				}
			HStack{Text(review.model.author)
				.font(.caption)
				.italic()
				Text("στις \(review.model.date.toGreekString())")
					.font(.caption)
					.italic()
			}
			StarsView(rating: review.model.grade)
			Text(review.model.description)
				.font(.body)
			Spacer()
				.navigationTitle("Κριτική")
		}
		if UserVM.currentUser.getUserID() != nil && review.model.authorID == UserVM.currentUser.getUserID()!{
			stack
				.toolbar{
					ToolbarItemGroup(placement: .primaryAction){
						Button("Επεξεργασία"){
							editViewShown=true
						}
					}
				}
				
		}else{
			stack
		}
    }
}

struct ReviewDetailView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView{
			ReviewDetailView(review: sampleRev())
		}
    }
	static func sampleRev()->ReviewViewModel{
		var dict = [String: Any]()
		
		dict["authorID"]="sd"
		dict["author"]="Author"
		dict["teacherID"]="teacherID"
		dict["teacherName"]="Teacher Name"
		let g: Float = 4.5
		dict["grade"]=g
		dict["title"]="Review Title"
		dict["description"]="Review Description"
		dict["date"]=Date().toString()
		let r = ReviewViewModel(model: Review(id: "sam rev", dict: dict)!)
		return r
	}
}

