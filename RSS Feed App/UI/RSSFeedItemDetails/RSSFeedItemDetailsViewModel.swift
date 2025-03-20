//
//  RSSFeedItemDetailsViewModel.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 19.03.2025..
//

import Foundation

class RSSFeedItemDetailsViewModel: ObservableObject {
    @Published var item: RSSFeedItemModel?
    
    init(item: RSSFeedItemModel? = nil) {
        self.item = item
    }
}
