//
//  HomeViewModel.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation

enum State {
    case success
    case error
    case loading
}

class HomeViewModel: ObservableObject {
    private var rssService: RSSServiceProtocol
    init(rssService: RSSServiceProtocol) {
        self.rssService = rssService
    }
    @Published var state: State = .loading
    @Published var fetched: Bool = false
    @Published var channelTitle: String = ""
    @Published var rssItems: [RSSFeedItem] = []
    @Published var rssChannels: [RSSChannel] = []
    var onChannelTapped: ((RSSChannel) -> Void)?
    
    func fetchRSSChannels() {
        state = .loading
        Task {
            do {
                let channels = try await rssService.fetchRSSChannels(from: "https://rss.feedspot.com/world_news_rss_feeds/")
                DispatchQueue.main.async { [weak self] in
                    self?.rssChannels = channels
                    self?.state = .success
                    self?.fetched = true
                    
                }
                //print("Found RSS Channels")
            }
            catch {
                self.state = .error
                print("Error: \(error)")
            }
        }
    }
    
    func fetchFeed(for channel: RSSChannel) {
        state = .loading
        Task {
            do {
                let items = try await rssService.fetchRSSFeed(url: channel.link)
                DispatchQueue.main.async { [weak self] in
                    self?.rssItems = items
                    self?.channelTitle = channel.name
                    self?.state = .success
                    //print("RSS ITEMS: \(String(describing: self?.rssItems))")
                }
                
            }
            catch {
                state = .error
                print("Failed to fetch or parse RSS feed: \(error.localizedDescription)")
            }
        }
    }
}
