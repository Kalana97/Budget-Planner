//
//  Category+CoreDataProperties.swift
//  
//
//  Created by Kalana Rathnayaka on 5/26/21.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var categoryName: String?
    @NSManaged public var budget: String?
    @NSManaged public var notes: String?
    @NSManaged public var colorName: String?
    @NSManaged public var expenses: Category?

}
