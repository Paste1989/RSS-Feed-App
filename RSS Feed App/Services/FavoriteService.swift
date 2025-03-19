//
//  FavoriteService.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 19.03.2025..
//

import Foundation

protocol FavoriteServiceProtocol {
    func getAllFavorites() -> [RSSChannelModel]
    func saveFavorites(channel: RSSChannelModel)
    func removeFavorites(channel: RSSChannelModel, index: Int)
    func isFavorite(data: RSSChannelModel) -> Bool
}

final class FavoriteService: FavoriteServiceProtocol {
    var persistenceService: PersistenceServiceProtocol
    init(persistenceService: PersistenceServiceProtocol) {
        self.persistenceService = persistenceService
    }
    
    func getAllFavorites() -> [RSSChannelModel] {
        return persistenceService.favorites
    }
    
    func saveFavorites(channel: RSSChannelModel) {
        if !isFavorite(data: channel) {
            persistenceService.favorites.insert(channel, at: 0)
        }
    }
    
    func removeFavorites(channel: RSSChannelModel, index: Int) {
        if isFavorite(data: channel) {
            for _ in persistenceService.favorites {
                guard let index = persistenceService.favorites.firstIndex(where: { $0.id == channel.id }) else { return }
                persistenceService.favorites.remove(at: index)
            }
        }
    }
    
    func isFavorite(data: RSSChannelModel) -> Bool {
        return persistenceService.favorites.contains(data)
    }
}
