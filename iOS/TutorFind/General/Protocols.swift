//
//  Protocols.swift
//  TutorFind
//
//  Created by Andreas Loizides on 28/11/2021.
//

import Foundation
protocol DictionaryCodable{
	init?(id: String, dict: [String: Any])
	init()
	func toDict()->[String: Any]
}
protocol StorableOnFirebase{
	static var basePathString: String {get}
	static var genericName: String	{get}
	var id: String	{get set}
}
