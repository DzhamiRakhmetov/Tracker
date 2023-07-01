//
//  WeekDayArrayTransformer.swift
//  Tracker
//
//  Created by Джами on 08.06.2023.
//

//import Foundation
//import CoreData
//
//class WeekManagedObject: NSManagedObject {
//    @NSManaged var schedule: [Int]
//}
//
//
//
//@objc(WeekDayArrayTransformer)
//class WeekDayArrayTransformer: NSSecureUnarchiveFromDataTransformer {
//    override class var allowedTopLevelClasses: [AnyClass] {
//        return [NSArray.self]
//    }
//    
//    //reqistration Class
//    static func reqister() {
//        let value = WeekDayArrayTransformer()
//        let name = NSValueTransformerName(String(describing: Self.self))
//        ValueTransformer.setValueTransformer(value, forName: name)
//    }
//    
//    
//    override class func transformedValueClass() -> AnyClass {
//        return NSArray.self
//    }
//    
//    override class func allowsReverseTransformation() -> Bool {
//        return true
//    }
//    
//    override func transformedValue(_ value: Any?) -> Any? {
//        if let weekDayArray = value as? [WeekDay] {
//            let intArray = weekDayArray.map { $0.rawValue }
//            return intArray
//        }
//        return nil
//    }
//    
//    override func reverseTransformedValue(_ value: Any?) -> Any? {
//        guard let nsArray = value as? [Int] else { return nil }
//        
//        let array = nsArray.compactMap { WeekDay(rawValue: $0)}
//        return array
//    }
//}
//
//
