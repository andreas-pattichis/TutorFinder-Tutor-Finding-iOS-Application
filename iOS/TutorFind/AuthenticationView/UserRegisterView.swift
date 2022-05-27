//
//  UserRegisterView.swift
//  TutorFind
//
//  Created by Sotiris Zenios
//

import SwiftUI
import MapKit
import LocationPicker
import CoreLocation
import CoreLocationUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
	let manager = CLLocationManager()


	override init() {
		super.init()
		manager.delegate = self
	}

	func requestLocation() {
		manager.requestLocation()
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let loc = locations.first{
			Professor.current.longitude = loc.coordinate.longitude
			Professor.current.latitude = loc.coordinate.latitude
		}
	}
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		if let clError = error as? CLError{
			switch clError.code{
			case .denied:
				UserVM.currentUser.showAlertMessage(message: "Χρειάζεται η άδειά σας για να βρεθεί η τοποθεσία σας!")
			default:
				UserVM.currentUser.showAlertMessage(message: "Δεν μπορούσε να εξακριβωθεί η τοποθεσία σας. Δοκιμάστε ξανά αργότερα.")
			}
			
		}
		
	}
}
@available(iOS 15.0, *)
struct UserRegisterView: View {
	@ObservedObject var user = UserVM.currentUser
	@ObservedObject var professor = Professor.current
	@StateObject var locManager = LocationManager()
	@Binding var isShown: Bool
	var body: some View {
		Form{
			Picker("Ρόλος", selection: $user.model.userType){
				ForEach(UserType.allCases){
					Text($0.rawValue).tag($0)
				}
			}
			.pickerStyle(SegmentedPickerStyle())
			Section("ΣΤΟΙΧΕΙΑ ΣΥΝΔΕΣΗΣ"){
				TextField("Εmail", text: $user.email)
				SecureField("Κωδικός", text: $user.password)
			}
			Section("ΠΡΟΣΩΠΙΚΑ ΣΤΟΙΧΕΙΑ"){
				TextField("Όνομα", text: $user.model.firstName)
				TextField("Επίθετο", text: $user.model.lastName)
				TextField("Τηλέφωνο", text: Binding(get: {
					if user.model.phoneNumber == 0{
						return ""
					}else{
						return String(user.model.phoneNumber)
					}
				}, set: {
					user.model.phoneNumber = Int($0) ?? 0
				}))
					.keyboardType(.numberPad)
				if user.model.userType == .teacher{
					TextField("Διεύθυνση", text: $professor.address)
					NavigationLink("Ακριβής Τοποθεσία"){
						ZStack{
						LocationPicker(instructions: "Πατήστε την τοποθεσία σας", coordinates: Binding(get: {
							CLLocationCoordinate2D(latitude: professor.latitude, longitude: professor.longitude)
						}, set: {
							professor.latitude = $0.latitude
							professor.longitude = $0.longitude
						}))
							LocationButton(.currentLocation){
								locManager.requestLocation()
							}
						}
					}
				}
				
			}
			if user.model.userType == .teacher{
				Section("ΠΡΟΦΙΛ"){
					TextField("Μία σύντομη περιγραφή σας", text: $professor.profileInfo)
					
					TextField("Βιογραφικό", text: $professor.bio)
				}
			}
			Button("Εγγραφή"){
				Task{
					if await user.signUp(){
						user.showingRegisterView=false
					}
				}
			}
		}
		.navigationTitle("Εγγραφή")
		.alert(user.alertMessage, isPresented: $user.alert, actions: {})
	}
}

@available(iOS 15.0, *)
struct UserRegisterView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView{
			UserRegisterView(isShown: .constant(true))
		}
	}
}
