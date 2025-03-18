//
//  RSSService.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation

enum ParseError: String {
    case invalidURL = "Invalid URL"
}

protocol RSSServiceProtocol {
    func fetchRSSChannels() async throws
    func fetchRSSFeed(url: String) async throws -> [RSSFeedItem]
    func getChannelsFromStorage() async throws -> [RSSChannelModel]
}

class RSSService: NSObject, RSSServiceProtocol, XMLParserDelegate {
    private let channelsURL: String = "https://rss.feedspot.com/world_news_rss_feeds/"
    private let rssParserService = ServiceFactory.rssParserService
    private let rssChannePersistanceService = RSSChannelService()
    private var channels: [RSSChannelModel] = []
    private var items: [RSSFeedItem] = []
    private var currentElement: String = ""
    private var currentTitle: String = ""
    private var currentLink: String = ""
    private var currentImage: String = ""
    private var currentDescription: String = ""
}

//MARK: - RSS Channels
extension RSSService {
    func fetchRSSChannels() async throws {
        guard let url = URL(string: channelsURL) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else {
                //throw URLError(.cannotDecodeContentData)
                return
            }
            
            let links = extractRSSLinks(from: html)
            for link in links {
                if let channelData = try? await fetchChannelData(from: link) {
                    let channelModel = RSSChannelModel(id: UUID(), name: channelData.name, image: channelData.image, link: link)
                    channels.append(channelModel)
                
                }
            }
            saveChannelsToStorage()
            print("CHANNELS COUN == \(channels.count)")
        }
        catch {
            print("Error fetching channels: \(error)")
        }
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
            throw NSError(domain: ParseError.invalidURL.rawValue, code: 400, userInfo: nil)
        }
        
        let (data, _) = try await URLSession.shared.data(from: feedURL)
        let parser = RSSParserService()
        
        return try parser.parseFeed(from: data)
    }
}

//MARK: - Core Data
extension RSSService {
    func saveChannelsToStorage() {
        for channelModel in channels {
            rssChannePersistanceService.saveRSSChannel(rssChannel: channelModel)
        }
        
    }
    
    func getChannelsFromStorage() async throws -> [RSSChannelModel] {
        print("channels from storage COUNT: \(rssChannePersistanceService.fetchRSSChannels().count)")
        return rssChannePersistanceService.fetchRSSChannels()
    }
}
