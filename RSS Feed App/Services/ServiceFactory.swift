//
//  ServiceFactory.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation

struct ServiceFactory {
    static var connectivityService: ConnectivityProtocol {
        return ConnectivityService()
    }
    
    static var coreDataService: CoreDataServiceProtocol {
        return CoreDataService()
    }
    
    static var persistenceService: PersistenceServiceProtocol {
        return PersistenceService()
    }
    
    static var rssService: RSSNNetworkServiceProtocol {
        return RSSNetworkService()
    }
    
    static var rssParserService: RSSParserServiceProtocol {
        return RSSParserService()
    }
    
    static var rssChannelsDataService: RSSChannelDataServiceProtocol {
        return RSSChannelDataService()
    }
    
    static var rssFeedDataServic: RSSFeedDataServiceProtocol {
        return RSSFeedDataService()
    }
    
    static var favoriteService: FavoriteServiceProtocol {
        return FavoriteService(persistenceService: Self.persistenceService)
    }
}
