//
//  ArticleItem+CoreDataProperties.swift
//  
//
//  Created by Akash Arora on 08/06/22.
//
//

import Foundation
import CoreData


extension ArticleItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleItem> {
        return NSFetchRequest<ArticleItem>(entityName: "ArticleItem")
    }

    @NSManaged public var articleDescription: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var queryText: String?
    @NSManaged public var sourceName: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?

}
