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
    var languageCode: String { get set }
}

final class PersistenceService: PersistenceServiceProtocol {
    struct Keys {
        static let isFirstTimeOpened = "isFirstTimeOpened"
        static let isInitalDataFetched = "isInitalDataFetched"
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
    
    var languageCode: String {
        get {
            return shared.string(forKey: Keys.languageCode) ?? "en"
        }
        set {
            shared.setValue(newValue, forKey: Keys.languageCode)
        }
    }
}

