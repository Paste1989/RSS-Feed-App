//
//  RSSItem.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation

struct RSSFeedItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String?
    let image: String?
    let link: String
    var categories: [String] = []
}
