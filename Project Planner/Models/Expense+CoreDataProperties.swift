//
//  Expense+CoreDataProperties.swift
//  
//
//  Created by Kalana Rathnayaka on 5/26/21.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var amount: String?
    @NSManaged public var date: String?
    @NSManaged public var addToCalendar: Bool
    @NSManaged public var occurrence: String?
    @NSManaged public var cat: NSSet?

}

// MARK: Generated accessors for cat
extension Expense {

    @objc(addCatObject:)
    @NSManaged public func addToCat(_ value: Expense)

    @objc(removeCatObject:)
    @NSManaged public func removeFromCat(_ value: Expense)

    @objc(addCat:)
    @NSManaged public func addToCat(_ values: NSSet)

    @objc(removeCat:)
    @NSManaged public func removeFromCat(_ values: NSSet)

}
