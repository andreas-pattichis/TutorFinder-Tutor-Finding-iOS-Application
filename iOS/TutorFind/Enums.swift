//
//  Enums.swift
//  TutorFind
//
//  Created by Andreas Loizides on 28/11/2021.
//

import Foundation
enum Akroatirio: String, Identifiable, CaseIterable{
	var id: String {return self.rawValue}
	
	case dontCare = "Όλα τα ακροατήρια"
	case notOnShopify = "Βιολογία 14:00-15:30"
	case localProblem = "Βιολογία 16:00-17:30"
}
enum SampleStudent: String, Identifiable, CaseIterable{
	var id: String {return self.rawValue}
	
	case dontCare = "Όλοι οι μαθητές"
	case localProblem = "Πέτρος Ανδρέου"
	case notOnShopify = "Μάριος Πέτρου"
	case sadfsd = "Ζένιος Μάριου"
}
