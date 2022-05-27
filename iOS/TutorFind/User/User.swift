//
//  User.swift
//  TutorFinder
//
//  Created by Andreas Loizides on 05/11/2021.
//

import Foundation
import Firebase
import SwiftUI
enum UserType: String, Identifiable, CaseIterable{
	var id: String {return rawValue}
	case student = "Μαθητής"
	case teacher = "Καθηγήτρια/τής"
}
struct User: Identifiable, Hashable, DictionaryCodable, StorableOnFirebase{
	internal init(id: String = "", firstName: String = "", lastName: String = "", userType: UserType = .student, phoneNumber: Int = 0) {
		self.id = id
		self.firstName = firstName
		self.lastName = lastName
		self.userType = userType
		self.phoneNumber = phoneNumber
	}
	
	var id = ""
	var firstName = ""
	var lastName = ""
	var userType: UserType = .student
	var phoneNumber: Int = 0
	var fullName: String{return "\(firstName) \(lastName)"}
	static var genericName: String = "Χρήστης"
	static var basePathString: String = "users"
	init?(id: String, dict: [String : Any]) {
		guard let firstName = dict["firstName"] as? String
				,let lastName = dict["lastName"] as? String
				,let userTypeString = dict["userType"] as? String
				,let userType = UserType(rawValue: userTypeString)
				,let phoneNumber = dict["phone"] as? Int else{return}
		self.firstName=firstName
		self.lastName=lastName
		self.phoneNumber=phoneNumber
		self.userType=userType
		self.id=id
	}
	init() {}
	func toDict() -> [String : Any] {
		var dict = [String: Any]()
		dict["firstName"] = firstName
		dict["lastName"] = lastName
		dict["userType"] = userType.rawValue
		dict["phone"] = phoneNumber
		return dict
	}
	static func samples()->[User]{
		return [
			User(id: "1", firstName: "Andreas", lastName: "Loizides", userType: .student, phoneNumber: 99719217)
			,User(id: "2", firstName: "Andreas", lastName: "Pattiches", userType: .student, phoneNumber: 99123456)
			,User(id: "3", firstName: "Christos", lastName: "Kasoulides", userType: .student, phoneNumber: 99987654)
			,User(id: "4", firstName: "Christos", lastName: "Eleftheriou", userType: .student, phoneNumber: 99654321)
		]
	}
}
class UserVM: MyViewModel<User>{
	
	static let currentUser = UserVM()
	@AppStorage("isSignedIn") var isSignedIn = false{
		didSet{
			print("changed")
		}
	}
	@Published var email = ""
	@Published var password = ""
	@Published var alert = false
	@Published var alertMessage = ""
	@Published var showingRegisterView = false
	private(set) var isConfigured = false
	var baseUsersCoursesReference: DatabaseReference {return Database.database().reference().child("user-courses")}
	func getUserID()->String?{
		return Auth.auth().currentUser?.uid
	}
	func getUserIDIfLoggedInOrShowMessageAndLogoutIfNot()->String?{
		guard let userID = Auth.auth().currentUser?.uid else{
			showAlertMessage(message: "Δεν είστε συνδεδεμένοι! Παρακαλώ επανασυνδεθείτε")
			logout()
			return nil
		}
//		let s = das
//		s
		return userID
	}
	func catchByShowingAlert(_ msg: String = "Παρακαλώ δοκιμάστε ξανά αργότερα.", _ throwing: (@escaping () async throws -> ()))async->Bool{
		do{
			try await throwing()
			return true
		}catch{
			self.showAlertMessage(message: msg)
			return false
		}
	}
	func catchByShowingAlert<T>(_ msg: String = "Παρακαλώ δοκιμάστε ξανά αργότερα.", _ throwing: (@escaping () async throws -> T))async->T?{
		do{
			return try await throwing()
		}catch{
			self.showAlertMessage(message: msg)
			return nil
		}
	}
	func registerToCourse(courseID: String)async{
		guard let userID = getUserIDIfLoggedInOrShowMessageAndLogoutIfNot() else {return}
				let myCoursesRef = baseUsersCoursesReference.child(userID)
		let _ = await catchByShowingAlert {
			myCoursesRef.updateChildValues([courseID: 0])
		}
	}
	func showAlertMessage(message: String) {
		DispatchQueue.main.async {
			self.alertMessage = message
			self.alert.toggle()
		}
	}
	var baseUserReference: DatabaseReference{return Database.database().reference().child("users")}
	private func loadInfo(userID: String, dict: [String: Any]){
		guard let m = User(id: userID, dict: dict) else{return}
		self.model=m
		self.objectWillChange.send()
		GlobalConfigurator.main.userInfoChanged(user: self, userID: userID)
	}
	private func createDict()-> [String: Any]{
		return model.toDict()
	}
	func loadAndObserveInfo(ofUserID userID: String){
		let userRef = self.baseUserReference.child(userID)
		self.observe(ref: userRef){[weak self] (userSnapshot) in
			if let userDict = userSnapshot.value as? [String: Any]{
				self?.loadInfo(userID: userID, dict: userDict)
			}
		}
	}
	func configureForLoggedInUser(userID: String){
		guard !isConfigured else{return}
		isConfigured=true
		loadAndObserveInfo(ofUserID: userID)
		DispatchQueue.main.async {
			self.isSignedIn = true
		}
	}
	func login()async -> Bool{
		// check if all fields are inputted correctly
		if email.isEmpty || password.isEmpty {
			showAlertMessage(message: "Εισάγετε email και κωδικό")
			return false
		}
		do{
			try await Auth.auth().signIn(withEmail: email, password: password)
			guard let userID = Auth.auth().currentUser?.uid else{
				showAlertMessage(message: "Παρακαλώ δοκιμάστε ξανά")
				return false
			}
			
			configureForLoggedInUser(userID: userID)
			return true
		}catch{
			showAlertMessage(message: "Σφάλμα σύνδεσης: \(error)")
			return false
		}
		
	}
	func allFieldsValidOrInformOtherwise()->Bool{
		if email.isEmpty || password.isEmpty {
			showAlertMessage(message: "Εισάγετε email και κωδικό")
			return false
		}
		if model.phoneNumber < 90000000{
			showAlertMessage(message: "Εισάγετε έγκυρο αριθμό τηλεφώνου")
			return false
		}
		if model.firstName == "" || model.lastName == ""{
			showAlertMessage(message: "Εισάγετε όνομα και επίθετο")
			return false
		}
		if model.userType == .teacher{
			guard (Professor.current.allFieldsValidOrInformOtherwise())else{
				return false
			}
		}
		return true
	}
	func registerNewUserDetails(userID: String)async throws{
		let dict = createDict()
		try await baseUserReference.updateChildValues([userID: dict])
	}
	func signUp() async -> Bool{
		guard allFieldsValidOrInformOtherwise() else{
			return false
		}
		// sign up with email and password
		do{
			
			try await Auth.auth().createUser(withEmail: email, password: password)
			guard let userID = Auth.auth().currentUser?.uid else{
				self.showAlertMessage(message: "Σφάλμα δημιουργίας χρήστη. Δοκιμάστε ξανά αργότερα.")
				return false
			}
			try await registerNewUserDetails(userID: userID)
			if model.userType == .teacher{
				do{
					print("Creating professor..")
					try await Professor.current.createProfessor()
					print("new professor created, adding observers and loggin in")
					Professor.current.observeProfessorDetails(id: userID)
					print("Success, logging in..")
					return await self.login()
				}catch{
					self.showAlertMessage(message: "Σφάλμα δημιουργώντας Καθηγητη: \(error)")
					return false
				}
			}else{
				print("Success, logging in..")
				return await self.login()
			}
		}catch{
			self.showAlertMessage(message: "\(error)")
			return false
		}
	}
	func clearData(){
		self.model = User()
		isConfigured=false
	}
	func logout() {
		do {
			try Auth.auth().signOut()
			clearData()
			isSignedIn = false
			email = ""
			password = ""
			GlobalConfigurator.main.loggedOut()
		} catch {
			print("Error signing out.")
		}
	}
}
