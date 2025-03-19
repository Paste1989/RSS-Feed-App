//
//  PersistenceService.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 18.03.2025..
//

import Foundation

protocol PersistenceServiceProtocol: AnyObject {
    var isFirstTimeOpened: Bool { get set }
    var isInitalDataFetched: Bool { get set }
    var favorites: [RSSChannelModel] { get set }
    var languageCode: String { get set }
}

final class PersistenceService: PersistenceServiceProtocol {
    struct Keys {
        static let isFirstTimeOpened = "isFirstTimeOpened"
        static let isInitalDataFetched = "isInitalDataFetched"
        static let favorites = "favorites"
        static let languageCode = "languageCode"
    }
    
    let shared = UserDefaults.standard
    
    var isFirstTimeOpened: Bool {
        get {
            return shared.bool(forKey: Keys.isFirstTimeOpened)
        }
        set {
            shared.setValue(newValue, forKey: Keys.isFirstTimeOpened)
        }
    }
    
    var isInitalDataFetched: Bool {
        get {
            return shared.bool(forKey: Keys.isInitalDataFetched)
        }
        set {
            shared.setValue(newValue, forKey: Keys.isInitalDataFetched)
        }
    }
    
    var favorites: [RSSChannelModel] {
        get {
            guard let data = UserDefaults.standard.object(forKey: Keys.favorites) as? Data else { return [] }
            if let dataArray = try? JSONDecoder().decode([RSSChannelModel].self, from: data) {
                return dataArray
            } else {
                return []
            }
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: Keys.favorites)
            }
        }
    }
    
    var languageCode: String {
        get {
            return shared.string(forKey: Keys.languageCode) ?? "en"
        }
        set {
            shared.setValue(newValue, forKey: Keys.languageCode)
        }
    }
}

