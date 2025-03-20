//
//  RSSService.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation
import CoreData

enum ParseError: String {
    case invalidURL = "Invalid URL"
}

protocol RSSNNetworkServiceProtocol {
    func fetchRSSChannels() async throws
    func fetchRSSFeed(url: String) async throws -> [RSSFeedItemModel]
    func saveChannelsToStorage()
    func getChannelsFromStorage() async throws -> [RSSChannelModel]
    func removeChannelsFromStorage() async
    func saveFeedsToStorage() async
    func getFeedItemsFromStorage() async throws -> [RSSFeedItemModel]
    func removeFeedItemsFromStorage() async
}

class RSSNetworkService: NSObject, RSSNNetworkServiceProtocol, XMLParserDelegate {
    private let channelsURL: String = "https://rss.feedspot.com/world_news_rss_feeds/"
    private let rssParserService = ServiceFactory.rssParserService
    private let rssChannelDataService = RSSChannelDataService()
    private let rssFeedDataService = RSSFeedDataService()
    private var channels: [RSSChannelModel] = []
    private var feedItems: [RSSFeedItemModel] = []
    private var currentElement: String = ""
    private var currentTitle: String = ""
    private var currentLink: String = ""
    private var currentImage: String = ""
    private var currentDescription: String = ""
}

//MARK: - RSS Channels
extension RSSNetworkService {
    func fetchRSSChannels() async throws {
        guard let url = URL(string: channelsURL) else { throw URLError.init(.badURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else {
                throw URLError(.cannotDecodeContentData)
            }
            
            let links = extractRSSLinks(from: html)
            for link in links {
                if let channelData = try? await fetchChannelData(from: link) {
                    let channelModel = RSSChannelModel(id: UUID(), name: channelData.name, image: channelData.image, link: link)
                    channels.append(channelModel)
                }
            }
            saveChannelsToStorage()
        }
        catch {
            print("Error fetching channels: \(error)")
            throw URLError(.badServerResponse)
        }
    }
    
    func fetchRSSFeed(url: String) async throws -> [RSSFeedItemModel] {
        guard let feedURL = URL(string: url) else {
            throw NSError(domain: ParseError.invalidURL.rawValue, code: 400, userInfo: nil)
        }
        let (data, _) = try await URLSession.shared.data(from: feedURL)
        let parser = RSSParserService()
        feedItems = try parser.parseFeed(from: data)
        await saveFeedsToStorage()
        
        return feedItems
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

//MARK: - Core Data
extension RSSNetworkService {
    func saveChannelsToStorage() {
        for channelModel in channels {
            rssChannelDataService.saveRSSChannel(rssChannel: channelModel)
        }
    }
    
    func getChannelsFromStorage() async throws -> [RSSChannelModel] {
        return rssChannelDataService.fetchRSSChannels()
    }
    
    func removeChannelsFromStorage() async {
        let rssChannels = rssChannelDataService.fetchRSSChannels()
        for channel in rssChannels {
            if let entity = await rssChannelDataService.getEntity(channel: channel) {
                rssChannelDataService.deleteRSSChannel(channel: entity)
            }
        }
    }
    
    func saveFeedsToStorage() async {
        for feedModel in feedItems {
            rssFeedDataService.saveRSSFeedItem(item: feedModel)
        }
    }
    
    func getFeedItemsFromStorage() async throws -> [RSSFeedItemModel] {
        return rssFeedDataService.fetchRSSFeedItems()
    }
    
    func removeFeedItemsFromStorage() async {
        let rssFeedItems = rssFeedDataService.fetchRSSFeedItems()

        for item in rssFeedItems {
            if let entity = await rssFeedDataService.getEntity(item: item) {
                rssFeedDataService.deleteRSSFeedItem(item: entity)
            }
        }
    }
}
