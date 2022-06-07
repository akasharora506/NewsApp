//
//  SourceItem+CoreDataProperties.swift
//  
//
//  Created by Akash Arora on 20/05/22.
//
//

import Foundation
import CoreData

extension SourceItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SourceItem> {
        return NSFetchRequest<SourceItem>(entityName: "SourceItem")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var sourceDescription: String?

}
