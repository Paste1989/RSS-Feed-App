//
//  RSSChannelService.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 18.03.2025..
//

import Foundation
import CoreData

protocol RSSChannelDataServiceProtocol {
    func saveRSSChannel(rssChannel: RSSChannelModel)
    func fetchRSSChannels() -> [RSSChannelModel]
    func deleteRSSChannel(channel: RSSChannelEntity)
}

class RSSChannelDataService: RSSChannelDataServiceProtocol {
    private let coreDataService = CoreDataService()
    private let context = CoreDataService().context

    func saveRSSChannel(rssChannel: RSSChannelModel) {
        let channelEntity = coreDataService.createEntity(ofType: RSSChannelEntity.self, context: context)
        channelEntity.id = rssChannel.id
        channelEntity.name = rssChannel.name
        channelEntity.image = rssChannel.image
        channelEntity.link = rssChannel.link
        
        coreDataService.saveContext(context: context)
    }

    func fetchRSSChannels() -> [RSSChannelModel] {
        let channelEntities: [RSSChannelEntity] = coreDataService.fetchEntities(ofType: RSSChannelEntity.self, context: context)
        return channelEntities.map { RSSChannelModel(id: $0.id ?? UUID(), name: $0.name ?? "", image: $0.image, link: $0.link ?? "") }
    }

    func deleteRSSChannel(channel: RSSChannelEntity) {
        coreDataService.deleteEntity(entity: channel, context: context)
    }
}
