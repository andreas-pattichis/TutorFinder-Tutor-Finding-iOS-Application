//
//  ProfessorViewModel.swift
//  TutorFinder
//
//  Created by Andreas Loizides on 16/11/2021.
//

import Foundation
import Firebase
import SwiftUI
enum Errors: Error{
	case noUserID(err: String? = nil)
}
class Professor: ViewModelThatObservesFireBaseData, ObservableObject{
	private init(){super.init(modelName: "Professor")}
	override init(modelName: String){
		super.init(modelName: modelName)
	}
	static let current = Professor()
	@Published var address: String = ""
	@Published var longitude: Double = 33.370487
	@Published var latitude: Double = 35.130101
	@Published var bio: String = ""
	@Published var profileInfo: String = ""
	var initialized = false
	var baseProfessorsReference: DatabaseReference {return Database.database().reference().child("professors")}
	private func loadInfo(professorDictionary: [String: Any]){
		guard let address = professorDictionary["address"] as? String
				,let long = professorDictionary["longitude"] as? Double
				,let lat = professorDictionary["latitude"] as? Double
				,let bio = professorDictionary["bio"] as? String
				,let profile = professorDictionary["profileInfo"] as? String
		else{
			UserVM.currentUser.showAlertMessage(message: "Error loading professor data. Dictionary: \(professorDictionary)")
			return
		}
		self.address=address
		self.longitude=long
		self.latitude=lat
		self.bio=bio
		self.profileInfo=profile
	}
	func observeProfessorDetails(id: String){
		
		let professorReference = baseProfessorsReference.child(id)
		self.observe(ref: professorReference){snapshot in
			if let dict = snapshot.value as? [String: Any]{
				self.loadInfo(professorDictionary: dict)
			}else{
				UserVM.currentUser.showAlertMessage(message: "Error loading professor data. No dictionary")
			}
		}
		
	}
	private func createDict()->[String: Any]{
		return [
			"address":address
			,"longitude": longitude
			,"latitude": latitude
			,"bio": bio
			,"profileInfo": profileInfo
		]
	}
	func allFieldsValidOrInformOtherwise()->Bool{
		guard address != "" && longitude != 0 && latitude != 0 else{
			UserVM.currentUser.showAlertMessage(message: "Εισάγετε έγκυρη διεύθυνση")
			return false
		}
		guard address != "" && longitude != 0 && latitude != 0 else{
			UserVM.currentUser.showAlertMessage(message: "Εισάγετε έγκυρη διεύθυνση")
			return false
		}
		guard bio != "" && profileInfo != "" else{
			UserVM.currentUser.showAlertMessage(message: "Εισάγετε μία σύντομη περιγραφή για τον εαυτό σας")
			return false
		}
		return true
	}
	func createProfessor()async throws{
		let user = UserVM.currentUser
		guard let id=user.getUserID() else {
			user.showAlertMessage(message: "No user ID")
			throw Errors.noUserID()
		}
		let dict = createDict()
		return baseProfessorsReference.updateChildValues([id:dict])
	}
	func loadModel(userID: String){
		observeProfessorDetails(id: userID)
		initialized=true
	}
	func signOut(){
		profileInfo=""
		bio=""
		address=""
		longitude=0
		latitude=0
		removeAllObservers()
		initialized=false
	}
}
