//
//  HomeViewModel.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation

enum FetchState {
    case none
    case success
    case error
    case loading
}

class HomeViewModel: ObservableObject {
    private var rssService: RSSServiceProtocol
    init(rssService: RSSServiceProtocol) {
        self.rssService = rssService
    }
    @Published var state: FetchState = .none
    @Published var fetched: Bool = false
    @Published var channelTitle: String = ""
    @Published var channelURL: String = ""
    @Published var rssFeedItems: [RSSFeedItem] = []
    @Published var rssChannels: [RSSChannel] = []
    
    func fetchRSSChannels() {
        state = .loading
        Task {
            do {
                let channels = try await rssService.fetchRSSChannels()
                DispatchQueue.main.async { [weak self] in
                    self?.rssChannels = channels
                    self?.state = .success
                    self?.fetched = true
                }
                //print("Found RSS Channels")
            }
            catch {
                DispatchQueue.main.async { [weak self] in
                    self?.state = .error
                }
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
                    self?.rssFeedItems = items
                    self?.channelTitle = channel.name
                    self?.channelURL = channel.link
                    self?.state = .success
                    //print("RSS ITEMS: \(String(describing: self?.rssFeedItems))")
                }
                
            }
            catch {
                DispatchQueue.main.async { [weak self] in
                    self?.state = .error
                }
                print("Failed to fetch or parse RSS feed: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchFeed(with url: String) {
        state = .loading
        Task {
            do {
                let items = try await rssService.fetchRSSFeed(url: url)
                DispatchQueue.main.async { [weak self] in
                    self?.rssFeedItems = items
                    self?.state = .success
                }
            }
            catch {
                DispatchQueue.main.async { [weak self] in
                    self?.state = .error
                }
                print("Failed to fetch or parse RSS feed: \(error.localizedDescription)")
            }
        }
    }
}
