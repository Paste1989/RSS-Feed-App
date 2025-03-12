//
//  RSSService.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation

enum PasrseError: String {
    case invalidURL = "Invalid URL"
}

protocol RSSServiceProtocol {
    func fetchRSSChannels(from url: String) async throws -> [RSSChannel]
    func fetchRSSFeed(url: String) async throws -> [RSSFeedItem]
}

class RSSService: NSObject, RSSServiceProtocol, XMLParserDelegate {
    let rssPasrerService = ServiceFactory.rssParserService
    private var items: [RSSFeedItem] = []
    private var currentElement = ""
    private var currentTitle = ""
    private var currentLink = ""
    private var currentImage = ""
    private var currentDescription = ""
}

//MARK: - RSS Channels
extension RSSService {
    func fetchRSSChannels(from url: String) async throws -> [RSSChannel] {
        guard let url = URL(string: url) else { throw URLError(.badURL) }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let html = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        let links = extractRSSLinks(from: html)
        var channels: [RSSChannel] = []
        
        for link in links {
            if let channelData = try? await fetchChannelData(from: link) {
                let ch = RSSChannel(name: channelData.name, image: channelData.image, link: link)
                channels.append(ch)
            }
        }
        return channels
    }
    
    private func extractRSSLinks(from html: String) -> [String] {
        let pattern = #"https?://[^\s"]+\.(xml|rss)"#
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        let matches = regex?.matches(in: html, range: NSRange(html.startIndex..., in: html)) ?? []
        
        var rssLinks: [String] = []
        for match in matches {
            if let range = Range(match.range, in: html) {
                let link = String(html[range])
                if !rssLinks.contains(link) {
                    rssLinks.append(link)
                }
            }
        }
        return rssLinks
    }
    
    private func fetchChannelData(from url: String) async throws -> (name: String, image: String?) {
        guard let feedURL = URL(string: url) else { throw URLError(.badURL) }
        
        let (data, _) = try await URLSession.shared.data(from: feedURL)
        let parser = RSSParserService()
        return try parser.parseChannel(from: data)
    }
}

//MARK: - RSS Feed
extension RSSService {
    func fetchRSSFeed(url: String) async throws -> [RSSFeedItem] {
        guard let feedURL = URL(string: url) else {
            throw NSError(domain: PasrseError.invalidURL.rawValue, code: 400, userInfo: nil)
        }
        
        let (data, _) = try await URLSession.shared.data(from: feedURL)
        let parser = RSSParserService()
        
        return try parser.parseFeed(from: data)
    }
}
