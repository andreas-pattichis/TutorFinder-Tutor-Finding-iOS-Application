//
//  View to display the review list, created by Andreas Pattichis
//

import Foundation
import Firebase
class ReviewListViewModel: MyListViewModel<Review, ReviewViewModel>{
	static var reviewsOfProfessorByID = [String: ReviewListViewModel]()
	static func ofProfessor(id: String)->ReviewListViewModel{
		if let r = reviewsOfProfessorByID[id]{
			return r
		}else{
			let r = ReviewListViewModel()
			r.observeProfessorReviews(ofID: id)
			reviewsOfProfessorByID[id]=r
			return r
		}
	}
		static var baseProfessorReviewsReference: DatabaseReference {
			return Database.database().reference().child("professors-reviews")
		}
	func observeProfessorReviews(ofID profID: String){
		observeFilteredByProperty(propertyName: "teacherID", equalTo: profID)
	}
}
//class ReviewListViewModel: ViewModelThatObservesFireBaseData, ObservableObject{
//	@Published private(set) var reviews = [ReviewViewModel]()
//	private var reviewIndexByID = [String: Int]()
//	static var baseProfessorReviewsReference: DatabaseReference {
//		return Database.database().reference().child("professors-reviews")
//	}
//	func observeProfessorReviews(ofID profID: String){
//		let idsReference = ReviewListViewModel.baseProfessorReviewsReference.child(profID)
//		observe(ref: idsReference){[weak self] (snap) in
//			guard let self = self else {return}
//			guard let reviewIDs = snap.value as? [String: Int] else {return}
//			for reviewID in reviewIDs.keys{
//				if self.reviewIndexByID[reviewID] != nil{
//					
//				} else{
//					let review = ReviewViewModel()
//					review.observeModel(id: reviewID)
//					review.loadAndObserveFromID(id: reviewID){[weak self] in
//						self?.objectWillChange.send()
//					}
//					self.reviewIndexByID[reviewID]=self.reviews.count
//					self.reviews.append(review)
//				}
//			}
//		}
//	}
//	
//}
