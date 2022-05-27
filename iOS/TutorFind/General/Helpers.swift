//
//  Helpers.swift
//  TutorFind
//
//  Created by Andreas Loizides on 28/11/2021.
//

import Foundation
import Firebase
import SwiftUI
struct GrowingButton: ButtonStyle {
	let isDisabled: Bool
	init(isDisabled: Bool = false){
		self.isDisabled=isDisabled
	}
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.padding()
			.background(isDisabled ? Color.gray : Color.blue)
			.foregroundColor(.white)
			.clipShape(Capsule())
			.scaleEffect(configuration.isPressed ? 1.2 : 1)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
	}
}
class ViewModelThatObservesFireBaseData{
	init(modelName: String){
		self.modelName=modelName
		self.queue = DispatchQueue(label: "\(modelName) viewmodel helper queue")
	}
	let modelName: String
	private var references = [DatabaseReference: Date]()
	private var queryRefs = [DatabaseQuery: Date]()
	private let queue: DispatchQueue
	
	func observe(ref: DatabaseReference, event: DataEventType = .value, onChange: @escaping ((DataSnapshot)->Void)){
		queue.sync {
			references[ref]=Date()
			ref.observe(event, with: onChange)
		}
	}
	func observe(ref: DatabaseQuery, event: DataEventType = .value, onChange: @escaping ((DataSnapshot)->Void)){
		queue.sync {
			queryRefs[ref]=Date()
			ref.observe(event, with: onChange)
		}
	}
	func removeAllObservers(){
		queue.sync{
			for ref in references.keys{
				ref.removeAllObservers()
			}
			for ref in queryRefs.keys{
				ref.removeAllObservers()
			}
			references.removeAll()
		}
	}
	deinit{
		removeAllObservers()
	}
}
