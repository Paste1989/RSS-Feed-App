//
//  HomeViewModel.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation

enum FetchState: Equatable {
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
    private var persistenceService: PersistenceServiceProtocol
    private var connectivityService: ConnectivityProtocol
    private var rssService: RSSServiceProtocol
    private let channelsDataService: RSSChannelDataServiceProtocol
    init(persistenceService: PersistenceServiceProtocol , rssService: RSSServiceProtocol, connectivityService: ConnectivityProtocol, channelsDataService: RSSChannelDataServiceProtocol) {
        self.persistenceService = persistenceService
        self.connectivityService = connectivityService
        self.rssService = rssService
        self.channelsDataService = channelsDataService
    }
    @Published var state: FetchState = .none
    @Published var currentChannel: RSSChannelModel?
    @Published var rssFeedItems: [RSSFeedItemModel] = []
    @Published var rssChannels: [RSSChannelModel] = []
    @Published var channels: [RSSChannelModel] = []
    @Published var isConnected: Bool = true
    
    func fetchRSSChannels() {
        print("channels fetching strated...")
        if isConnected == checkInternetConnection() {
            DispatchQueue.main.async { [weak self] in
                self?.state = .loading(type: .channel)
            }
            Task {
                do {
                    try await rssService.fetchRSSChannels()
                    DispatchQueue.main.async { [weak self] in
                        self?.state = .success(type: .channel)
                        print("channels fetching finished...")
                        self?.initalDataFetched()
                        self?.getChannelsfromStorage()
                    }
                }
                catch {
                    DispatchQueue.main.async { [weak self] in
                        self?.state = .error(type: .channel)
                    }
                    print("Error fetcing channels: \(error)")
                }
            }
        }
        else {
            DispatchQueue.main.async { [weak self] in
                self?.isConnected = false
            }
        }
    }
    
    func getChannelsfromStorage() {
        Task {
            do {
                let channels = try await rssService.getChannelsFromStorage()
                DispatchQueue.main.async { [weak self] in
                    if !channels.isEmpty {
                        self?.state = .success(type: .channel)
                        self?.rssChannels = channels
                    }
                    else {
                        self?.state = .loading(type: .channel)
                    }
                }
            }
            catch {
                DispatchQueue.main.async { [weak self] in
                    self?.state = .error(type: .channel)
                }
                print("Error getting channels from storage: \(error)")
            }
        }
    }
    
    func removeChannels() async {
        await rssService.removeChannelsFromStorage()
    }
    
    func fetchFeed(for channel: RSSChannelModel) {
        if isConnected == checkInternetConnection() {
            DispatchQueue.main.async { [weak self] in
                self?.state = .loading(type: .feed)
            }
            Task {
                do {
                    let items = try await rssService.fetchRSSFeed(url: channel.link)
                    DispatchQueue.main.async { [weak self] in
                        self?.currentChannel = channel
                        self?.rssFeedItems = items
                        self?.state = .success(type: .feed)
                        
                        if let self = self, !self.channels.contains(where: { $0.link == channel.link }) {
                            self.channels.insert(channel, at: 0)
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
        else {
            DispatchQueue.main.async { [weak self] in
                self?.isConnected = false
            }
        }
    }
    
    func fetchFeed(with url: String) {
        if isConnected == checkInternetConnection() {
            DispatchQueue.main.async { [weak self] in
                self?.state = .loading(type: .feed)
            }
            Task {
                do {
                    let items = try await rssService.fetchRSSFeed(url: url)
                    DispatchQueue.main.async { [weak self] in
                        self?.rssFeedItems = items
                        self?.currentChannel?.link = url
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
        else {
            DispatchQueue.main.async { [weak self] in
                self?.isConnected = false
            }
        }
    }
    
    func getFeedItemsfromStorage() {
        Task {
            do {
                let items = try await rssService.getFeedItemsFromStorage()
                DispatchQueue.main.async { [weak self] in
                    if !items.isEmpty {
                        self?.currentChannel?.name = self?.channels.last?.name ?? Localizable.last_searched_description.localized
                        self?.state = .success(type: .feed)
                        self?.rssFeedItems = items
                    }
                    else {
                        self?.state = .loading(type: .feed)
                    }
                }
            }
            catch {
                DispatchQueue.main.async { [weak self] in
                    self?.state = .error(type: .feed)
                }
                print("Error getting feed from storage: \(error)")
            }
        }
    }
    
    func reloadChannels() async {
        if isConnected == checkInternetConnection() {
            DispatchQueue.main.async { [weak self] in
                self?.state = .loading(type: .channel)
            }
            await removeChannels()
            fetchRSSChannels()
        }
        else {
            DispatchQueue.main.async { [weak self] in
                self?.isConnected = false
            }
        }
    }
    
    
    func removeFeedItemsFromStorage() async {
        await rssService.removeFeedItemsFromStorage()
        DispatchQueue.main.async { [weak self] in
            self?.rssFeedItems.removeAll()
            self?.currentChannel = nil
            self?.state = .none
        }
    }
    
    func checkInternetConnection() -> Bool {
        return connectivityService.checkInternetConnection()
    }
    
    func initalDataFetched() {
        persistenceService.isInitalDataFetched = true
    }
    
    func isInitalDataFetched() -> Bool {
        persistenceService.isInitalDataFetched
    }
}
