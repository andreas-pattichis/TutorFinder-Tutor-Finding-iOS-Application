//
//  GenericListVM.swift
//  TutorFind
//
//  Created by Andreas Loizides on 28/11/2021.
//

import Foundation
import Firebase
import Combine

class MyListViewModel<T: DictionaryCodable & StorableOnFirebase, W: MyViewModel<T>>: ViewModelThatObservesFireBaseData, ObservableObject{
	@Published var models:[W] = [W]()
	var nv: AnyCancellable?=nil
	override init(modelName: String="") {
		super.init(modelName: modelName)
		self.models = [W]()
		self.nv = models.publisher.sink{vm in
			print("rec \(vm.model.id)")
			self.objectWillChange.send()
		}
	}
	var anys = [String: AnyCancellable]()
	func makeSureOnlyTheseIDsAreObserved(ids: [String]){
		for currentID in self.models.map({$0.model.id}){
			if !ids.contains(currentID){
				remove(id: currentID)
			}
		}
		for newID in ids{
			if !self.models.contains(where: {$0.model.id == newID}){
				let vm = W()
				vm.observeModel(id: newID)
				add(vm)
			}
		}
	}
	func add(_ model: T){
		let id = model.id
		let vm = W(model: model)
		vm.observeModel(id: id)
		add(vm)
	}
	func add(_ vm: W){
		print("!!!!!!!!!!DEBUG!!!!!!!!!!")
		print("!!!!!!!!!!ADD \(vm.model.id)!!!!!!!!!!")
		printDebug()
		attatch(vm)
		self.models.append(vm)
	}
	func remove(id: String){
		self.anys.removeValue(forKey: id)
		self.models.removeAll(where: {$0.model.id == id})
	}
	func remove(_ vm: W){
		remove(id: vm.model.id)
	}
	private func attatch(_ vm: W){
		let id = vm.model.id
		guard self.anys[id] == nil else {return}
		let cancellable = vm.objectWillChange.sink{[weak self] in
			self?.objectWillChange.send()
			self?.printDebug()
		}
		self.anys[id]=cancellable
	}
	private func loadFromSnaphot(_ snapshot: DataSnapshot){
		guard let dicts = snapshot.value as? [String: [String: Any]] else{
			UserVM.currentUser.showAlertMessage(message: "Σφαλμα φόρτωσης. Δοκιμάστε ξανά αργότερα. (\(self.modelName) not a valid dictionary)")
			return
		}
		guard let theModels = dicts.strictMap(mapping: {dict in
			T(id: dict.key, dict: dict.value)
		})else{
			UserVM.currentUser.showAlertMessage(message: "Σφαλμα φόρτωσης. Δοκιμάστε ξανά αργότερα. (\(self.modelName) not a valid dictionary)")
			return
		}
		for model in theModels {
			if let index = self.models.firstIndex(where: {$0.model.id == model.id}){
				self.models[index].model=model
			}else{
				add(model)
			}
		}
	}
	func printDebug(){
		print("-----------INDICES-----------")
		print("Models:")
		for i in 0..<models.count {
			print("IN \(i): \(models[i].model.id)\t\(models[i].model.toDict())")
		}
		print("-----------END-----------")
	}
	func modelFromSnaphot(_ snapshot: DataSnapshot)->T?{
		guard let dict = snapshot.value as? [String: Any] else{
			UserVM.currentUser.showAlertMessage(message: "Σφαλμα φόρτωσης. Δοκιμάστε ξανά αργότερα. (\(self.modelName) not a valid dictionary (id: \(snapshot.key))")
			return nil
		}
		return T(id: snapshot.key, dict: dict)
	}
	private func onAdded(snapshot: DataSnapshot){
		guard let model = modelFromSnaphot(snapshot) else{return}
		add(model)
	}
	private func onRemoved(snapshot: DataSnapshot){
		guard let model = modelFromSnaphot(snapshot) else{return}
		remove(id: model.id)
	}
	func observeAll(ofID: String? = nil){
		let reference = ofID == nil ? MyViewModel<T>.baseReference : MyViewModel<T>.baseReference.child(ofID!)
		
		observe(ref: reference, event: .childRemoved){[weak self] (snapshot) in
			self?.onRemoved(snapshot: snapshot)
		}
		observe(ref: reference, event: .childAdded){[weak self] (snapshot) in
			self?.onAdded(snapshot: snapshot)
		}
	}
	func observeFilteredByProperty(propertyName: String, equalTo value: Any){
		let reference = MyViewModel<T>.baseReference
		let query = reference.queryOrdered(byChild: propertyName).queryEqual(toValue: value)
		observe(ref: query, event: .childRemoved){[weak self](snapshot) in
			self?.onRemoved(snapshot: snapshot)
		}
		observe(ref: query, event: .childAdded){[weak self](snapshot) in
			self?.onAdded(snapshot: snapshot)
		}
	}
}
