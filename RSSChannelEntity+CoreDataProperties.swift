//
//  RSSChannelEntity+CoreDataProperties.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 18.03.2025..
//
//

import Foundation
import CoreData


extension RSSChannelEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RSSChannelEntity> {
        return NSFetchRequest<RSSChannelEntity>(entityName: "RSSChannelEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var image: String?
    @NSManaged public var link: String?
    @NSManaged public var name: String?

}

extension RSSChannelEntity : Identifiable {

}
