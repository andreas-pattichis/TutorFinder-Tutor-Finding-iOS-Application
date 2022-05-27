//
//  UserView.swift
//  TutorFinder
//
//  Created by Andreas Loizides on 17/11/2021.
//

import SwiftUI
import MapKit


struct UserView: View {
	@ObservedObject var user = UserVM.currentUser
	@ObservedObject var prof = Professor.current
	var body: some View {
		List{
			HStack{
				Text(user.model.firstName)
				Spacer()
				Text(user.model.lastName)
			}
			Label("\(user.model.phoneNumber)", systemImage: "phone")
			if user.model.userType == .teacher{
				Label("\(prof.profileInfo)", systemImage: "person")
				Text(prof.bio)
					.font(.body)
				Label("\(prof.address)", systemImage: "house")
				SimpleMapView(longitude: prof.longitude, latitude: prof.latitude)
			}
		}
		.navigationTitle("Εγώ")
	}
}

struct UserView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView{
			UserView()
		}
	}
}
