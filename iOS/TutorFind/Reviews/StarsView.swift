//
//  View to display the rating of the review, created by Andreas Pattichis
//

import SwiftUI

struct StarsView: View {
	private static let MAX_RATING: Float = 5
	private static let COLOR = Color.orange
	
	let rating: Float
	
	var body: some View {
		HStack {
			ForEach(0..<Int(rating), id: \.self) { _ in
				self.fullStar
			}
			if Int(rating) + Int(StarsView.MAX_RATING - rating) < Int(StarsView.MAX_RATING){
				self.halfFullStar
			}
			ForEach(0..<Int(StarsView.MAX_RATING - rating), id: \.self) { _ in
				self.emptyStar
			}
		}
	}
	
	private var fullStar: some View {
		Image(systemName: "star.fill").foregroundColor(StarsView.COLOR)
	}
	
	private var halfFullStar: some View {
		Image(systemName: "star.lefthalf.fill").foregroundColor(StarsView.COLOR)
	}
	
	private var emptyStar: some View {
		Image(systemName: "star").foregroundColor(StarsView.COLOR)
	}
}

struct StarsView_Previews: PreviewProvider {
	static var previews: some View {
		StarsView(rating: 0.5)
	}
}
