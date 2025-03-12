//
//  ServiceFactory.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation

struct ServiceFactory {
    static var rssService: RSSServiceProtocol {
        return RSSService()
    }
    
    static var rssParserService: RSSParserServiceProtocol {
        return RSSParserService()
    }
}
