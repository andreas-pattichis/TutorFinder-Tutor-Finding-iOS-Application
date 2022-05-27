//
//  Extensions.swift
//  TutorFinder
//
//  Created by Andreas Loizides on 28/11/2021.
//

import Foundation
import UIKit
import SwiftUI
extension Collection{
	func strictMap<NewElement>(mapping: (Element)->NewElement?)->[NewElement]?{
		let mapped: [NewElement] = compactMap(mapping)
		guard mapped.count == count else{return nil}
		return mapped
	}
}

let wholeDateFormatter = DateFormatter(withFormat: "dd-MM-yyyy HH:mm")

extension Date{
	func minuteAndHourString()->String{
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		return dateFormatter.string(from: self)
	}
	static func fromString(string: String)->Date?{
		return wholeDateFormatter.date(from: string)
	}
	func toString()->String{
		return wholeDateFormatter.string(from: self)
	}
	func toGreekString()->String{
		let df = DateFormatter()
		df.locale = Locale.init(identifier: "el-CY")
		df.dateStyle = .long
		return df.string(from: self)
	}
}
extension String: Identifiable{
	public var id:String {return self}
}
extension DateFormatter{
	convenience init(withFormat format: String){
		self.init()
		dateFormat=format
	}
}
extension Color{
	init?(hexString: String){
		guard let hex = Int(hexString, radix: 16) else {return nil}
		self.init(
			red: Double((hex & 0xFF0000) >> 16) / 255.0,
			green: Double((hex & 0x00FF00) >> 8) / 255.0,
			blue: Double(hex & 0x0000FF) / 255.0
		)
	}
	func toHexString()->String{
		var hex = Int("0", radix: 16)!
		let (r,g,b,_) = UIColor(self).rgba
		let red = Int(r*255.0)
		let green = Int(g*255.0)
		let blue = Int(b*255.0)
		hex |= (red << 16)
		hex |= (green << 8)
		hex |= blue
		return String(hex, radix: 16, uppercase: true)
	}
}
extension UIColor {
	var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		
		getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		return (red, green, blue, alpha)
	}
}
extension Array where Element == CourseViewModel{
	func applyingFilters(taksi: Taksi, schoolType: SchoolType, classType: ClassType, searchText: String)->[CourseViewModel]{
		let arr = self.filter({$0.model.isIncluded(taksi: taksi, schoolType: schoolType, classType: classType, searchText: searchText)})
		return arr
	}
}
extension Course{
	func isIncluded(taksi: Taksi, schoolType: SchoolType, classType: ClassType, searchText: String)->Bool{
		let course = self
		if taksi != .any{
			guard course.taksi == taksi else{return false}
		}
		if schoolType != .any{
			guard course.schoolType == schoolType else {return false}
		}
		if classType != .dontCare{
			guard course.classType == classType else {return false}
		}
		guard searchText == "" || searchText == " " else{
			return course.title.contains(searchText)
		}
		return true
	}
}
extension Array where Element == Course{
	func applyingFilters(taksi: Taksi, schoolType: SchoolType, classType: ClassType, searchText: String)->[Course]{
		return self.filter{course in
			return course.isIncluded(taksi: taksi, schoolType: schoolType, classType: classType, searchText: searchText)
		}
	}
}
extension Course{
	static func sample()->CourseListViewModel{
		let list = CourseListViewModel()
		list.models = Course.data.map{CourseViewModel(model: $0)}
		return list
	}
}

