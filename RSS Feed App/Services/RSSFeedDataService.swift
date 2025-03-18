//
//  RSSFeedDataServiceProtocol.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 18.03.2025..
//

import Foundation

protocol RSSFeedDataServiceProtocol {
    func saveRSSFeedItem(item: RSSFeedItemModel)
    func fetchRSSFeedItems() -> [RSSFeedItemModel]
    func deleteRSSFeedItem(item: RSSFeedEntity)
}

class RSSFeedDataService: RSSFeedDataServiceProtocol {
    private let coreDataService = CoreDataService()
    private let context = CoreDataService().context
    
    func saveRSSFeedItem(item: RSSFeedItemModel) {
        let feedItemEntity = coreDataService.createEntity(ofType: RSSFeedEntity.self, context: context)
        feedItemEntity.id = item.id
        feedItemEntity.title = item.title
        feedItemEntity.feedDescription = item.description
        feedItemEntity.image = item.image
        feedItemEntity.link = item.link
        
        coreDataService.saveContext(context: context)
    }
    
    func fetchRSSFeedItems() -> [RSSFeedItemModel] {
        let feedEntities: [RSSFeedEntity] = coreDataService.fetchEntities(ofType: RSSFeedEntity.self, context: context)
        return feedEntities.map { RSSFeedItemModel(id: $0.id ?? UUID(), title: $0.title ?? "", description: $0.feedDescription ?? "", image: $0.image, link: $0.link ?? "") }
    }
    
    func deleteRSSFeedItem(item: RSSFeedEntity) {
        coreDataService.deleteEntity(entity: item, context: context)
    }
    
    func getEntity(item: RSSFeedItemModel) async -> RSSFeedEntity? {
        return await coreDataService.getEntity(for: item)
    }
}

