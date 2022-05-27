//
//  GenericVM.swift
//  TutorFind
//
//  Created by Andreas Loizides on 28/11/2021.
//

import Foundation
import Firebase
import Combine

class MyViewModel<T: DictionaryCodable & StorableOnFirebase>:ViewModelThatObservesFireBaseData, ObservableObject, Identifiable{
	@Published var model = T()
	var isInitialized = false
	static var baseReference: DatabaseReference{return Database.database().reference().child(T.basePathString)}
	
	required init(){super.init(modelName: T.genericName)}
	required init(model: T){
		super.init(modelName: T.genericName)
		self.model=model
		isInitialized=true
	}
	func observeAndFindByProperty(propertyName: String, equalTo value: Any){
		let reference = MyViewModel<T>.baseReference
		let query = reference.queryEqual(toValue: value, childKey: propertyName)
		observe(ref: query, event: .value){[weak self] (snapshot) in
			self?.loadFromSnapshot(snapshot: snapshot)
		}
		
	}
	static func getModel(id: String)async throws -> T?{
		let reference = MyViewModel<T>.baseReference
		let element = reference.child(id)
		let snapshot = try await element.getData()
		guard snapshot.exists() else{return nil}
		guard let dict = snapshot.value as? [String: Any] else {return nil}
		return T(id: id, dict: dict)
	}
	func observeModel(id: String){
		self.model.id=id
		print("[OBSERVE] request \(modelName) w id \(id)")
		let elementReference = MyViewModel<T>.baseReference.child(id)
		observe(ref: elementReference){[weak self] (snapshot) in
			print("[OBSERVE] received \(self?.modelName) w id \(id)")
			self?.loadFromSnapshot(snapshot: snapshot)
			self?.objectWillChange.send()
		}
	}
	private func loadFromSnapshot(snapshot: DataSnapshot){
		guard let dict = snapshot.value as? [String: Any] else{
			//could be deleted
			return
		}
		let id = snapshot.key
		guard let updatedElement = T(id: id, dict: dict) else{
			UserVM.currentUser.showAlertMessage(message: "Σφάλμα φόρτωσης \(self.modelName) (λανθασμένη μορφή δεδομένων)")
			return
		}
		self.model=updatedElement
		if !isInitialized {self.isInitialized=true}
		print("[OBSERVE] sent for \(self.modelName)")
		self.objectWillChange.send()
	}
	func publishNewModel(customID: String? = nil)async->Bool{
		var theID: String?
		if let customID = customID {
			theID=customID
		}else{
			let path = MyViewModel<T>.baseReference.childByAutoId()
			guard let givenID = path.key else{
				UserVM.currentUser.showAlertMessage(message: "Σφάλμα φόρτωσης δημιουργίας. Δοκιμάστε ξανά αργότερα")
				return false
			}
			theID=givenID
		}
		model.id=theID!
		objectWillChange.send()
		let hasUpdated = await updateModel()
		if hasUpdated{
			isInitialized=true
		}
		return hasUpdated
	}
	func updateModel()async->Bool{
		let elementPath = MyViewModel<T>.baseReference.child(model.id)
		return await UserVM.currentUser.catchByShowingAlert {
			try await elementPath.setValue(self.model.toDict())
		}
	}
	
}
