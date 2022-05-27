//
//  UserSignInView.swift
//  TutorFind
//
//  Created by Sotiris Zenios
//

import SwiftUI

@available(iOS 15.0, *)
struct UserSignInView: View {
	enum SampleIndex:String, CaseIterable, Identifiable{
		var id:String  {return rawValue}
		case zero = "0"
		case one = "1"
		case two = "2"
	}
	enum SampleKind: String, CaseIterable, Identifiable{
		var id: String {return rawValue}
		case student = "Μαθητής"
		case professor = "Εκπαιδευτικός"
	}
	struct SampleUserAuthDetails{
		private init(email: String, pass: String) {
			self.email = email
			self.pass = pass
		}
		let email: String
		let pass: String
		static let students = [
			SampleUserAuthDetails(email: "student1@fake.com", pass: "password")
			,SampleUserAuthDetails(email: "student2@fake.com", pass: "password")
			,SampleUserAuthDetails(email: "student3@fake.com", pass: "password")
		]
		static let professors = [
			SampleUserAuthDetails(email: "professor1@fake.com", pass: "password")
			,SampleUserAuthDetails(email: "professor2@fake.com", pass: "password")
			,SampleUserAuthDetails(email: "professor3@fake.com", pass: "password")
		]
	}
	@State private var sampleIndex = SampleIndex.zero
	@State private var sampleKind = SampleKind.student
	@State private var showingSampleSelection = true
	@ObservedObject var user = UserVM.currentUser
	var body: some View {
		VStack{
			Form{
				TextField("Email", text: $user.email)
				SecureField("Κωδικός", text: $user.password)
			}
			.navigationTitle("TutorFind")
			.alert(user.alertMessage, isPresented: $user.alert, actions: {})
			Button("Σύνδεση"){
				Task{
					await user.login()
				}
			}
			.buttonStyle(GrowingButton())
			if showingSampleSelection{
				HStack{
				VStack{FilterSelectionView(selectedValue: $sampleKind, label: "Είδος Χρήστη")
				FilterSelectionView(selectedValue: $sampleIndex, label: "Αριθμός Δείγματος")}
					Button("Συμπλήρωση", action: fillSample)
					.buttonStyle(GrowingButton())
				}
			}
			Text("Δεν έχετε λογαριασμό;")
			Button("Δημιουργία λογαριασμού"){
				user.showingRegisterView=true
			}
			Spacer()
		}
		.onShake {
			withAnimation{
				self.showingSampleSelection.toggle()
			}
		}
	}
	func fillSample(){
		let samples = self.sampleKind == .student ? SampleUserAuthDetails.students : SampleUserAuthDetails.professors
		guard let index = Int(sampleIndex.rawValue)else{return}
		guard index >= 0 &&
				index < samples.count else{return}
		let sample = samples[index]
		user.email=sample.email
		user.password=sample.pass
	}
	func loginSample(_ sample: SampleUserAuthDetails){
		user.email=sample.email
		user.password=sample.pass
		Task{
			await user.login()
		}
	}
}

@available(iOS 15.0, *)
struct UserSignInView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView{
			UserSignInView()
		}
	}
}

//Create a notification identifier for the shake event
extension UIDevice {
	static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

//  Override default behavior so the above notification is sent when the device is shaken
extension UIWindow {
	 open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		if motion == .motionShake {
			NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
		}
	 }
}

// View modifier for device shake event
struct DeviceShakeViewModifier: ViewModifier {
	let action: () -> Void

	func body(content: Content) -> some View {
		content
			.onAppear()
			.onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
				action()
			}
	}
}

// View extension for device shake event
extension View {
	func onShake(perform action: @escaping () -> Void) -> some View {
		self.modifier(DeviceShakeViewModifier(action: action))
	}
}
//onShake modifier inspired by a HackingWithSwiftArticle (https://www.hackingwithswift.com/quick-start/swiftui/how-to-detect-shake-gestures)
