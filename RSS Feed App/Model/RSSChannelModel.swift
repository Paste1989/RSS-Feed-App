//
//  RSSChannel.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 12.03.2025..
//

import Foundation

struct RSSChannelModel: Identifiable, Equatable {
    let id: UUID
    let name: String
    let image: String?
    let link: String
}
