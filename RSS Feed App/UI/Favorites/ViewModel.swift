//
//  FavoritesViewModel.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation

class FavoritesViewModel: ObservableObject {
    var persistenceService: PersistenceServiceProtocol
    var favoriteService: FavoriteServiceProtocol
    init(persistenceService: PersistenceServiceProtocol, favoriteService: FavoriteServiceProtocol) {
        self.persistenceService = persistenceService
        self.favoriteService = favoriteService
    }
    @Published var favoritesData: [RSSChannelModel] = []
    
    var onShouldShowDetails: ((RSSChannelModel) -> Void)?
    var onTapped: (() -> Void)?
    
    func getAllFavoriteChannels() -> [RSSChannelModel] {
        return persistenceService.favorites.reversed()
    }
    
    func favoriteTapped(data: RSSChannelModel, index: Int) {
        favoriteService.removeFavorites(channel: data, index: index)
        favoritesData = getAllFavoriteChannels()
    }
}
