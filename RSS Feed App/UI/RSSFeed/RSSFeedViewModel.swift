//
//  HomeViewModel.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation

enum FetchState {
    case none
    case success(type: ContentType)
    case error(type: ContentType)
    case loading(type: ContentType)

    enum ContentType {
        case channel
        case feed
    }
}

class RSSFeedViewModel: ObservableObject {
    private var rssService: RSSServiceProtocol
    private var connectivityService: ConnectivityProtocol
    init(rssService: RSSServiceProtocol, connectivityService: ConnectivityProtocol) {
        self.rssService = rssService
        self.connectivityService = connectivityService
    }
    @Published var state: FetchState = .none
    @Published var fetched: Bool = false
    @Published var currentChannel: RSSChannel?
    @Published var channelTitle: String = ""
    @Published var channelURL: String = ""
    @Published var rssFeedItems: [RSSFeedItem] = []
    @Published var rssChannels: [RSSChannel] = []
    @Published var channels: [RSSChannel] = []
    
    func fetchRSSChannels() {
        state = .loading(type: .channel)
        Task {
            do {
                let channels = try await rssService.fetchRSSChannels()
                DispatchQueue.main.async { [weak self] in
                    self?.rssChannels = channels
                    self?.state = .success(type: .channel)
                    self?.fetched = true
                }
                //print("Found RSS Channels")
            }
            catch {
                DispatchQueue.main.async { [weak self] in
                    self?.state = .error(type: .channel)
                }
                print("Error: \(error)")
            }
        }
    }
    
    func fetchFeed(for channel: RSSChannel) {
        state = .loading(type: .feed)
        Task {
            do {
                let items = try await rssService.fetchRSSFeed(url: channel.link)
                DispatchQueue.main.async { [weak self] in
                    self?.currentChannel = channel
                    self?.rssFeedItems = items
                    self?.channelTitle = self?.currentChannel?.name ?? ""
                    self?.channelURL = self?.currentChannel?.link ?? ""
                    self?.state = .success(type: .feed)
                    
                    
                    if let self = self, !self.channels.contains(where: { $0.link == channel.link }) {
                        self.channels.append(channel)
                    }
                }
            }
            catch {
                DispatchQueue.main.async { [weak self] in
                    self?.state = .error(type: .feed)
                }
                print("Failed to fetch or parse RSS feed: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchFeed(with url: String) {
        state = .loading(type: .feed)
        Task {
            do {
                let items = try await rssService.fetchRSSFeed(url: url)
                DispatchQueue.main.async { [weak self] in
                    self?.rssFeedItems = items
                    self?.channelTitle = self?.channelTitle ?? Localizable.news_title.localized
                    self?.channelURL = url
                    self?.state = .success(type: .feed)
                }
            }
            catch {
                DispatchQueue.main.async { [weak self] in
                    self?.state = .error(type: .feed)
                }
                print("Failed to fetch or parse RSS feed: \(error.localizedDescription)")
            }
        }
    }
    
    func checkInternetConnection() -> Bool {
        return connectivityService.isConnected
    }
}
