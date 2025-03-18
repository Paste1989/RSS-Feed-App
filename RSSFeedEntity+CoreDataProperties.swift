//
//  RSSFeedEntity+CoreDataProperties.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 18.03.2025..
//
//

import Foundation
import CoreData


extension RSSFeedEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RSSFeedEntity> {
        return NSFetchRequest<RSSFeedEntity>(entityName: "RSSFeedEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var image: String?
    @NSManaged public var link: String?
    @NSManaged public var feedDescription: String?

}
