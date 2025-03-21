//
//  HomeCoordinator.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation
import UIKit
import SwiftUI

class RSSFeedCoordinator: Coordinator {
    private let navigationController: UINavigationController = UINavigationController()

    func start() -> UIViewController {
        createHomeScreen()
    }
    
    private func createHomeScreen() -> UIViewController {
        let vm = RSSFeedViewModel(persistenceService: ServiceFactory.persistenceService, rssService: ServiceFactory.rssService, connectivityService: ServiceFactory.connectivityService, channelsDataService: ServiceFactory.rssChannelsDataService, favoriteService: ServiceFactory.favoriteService)
        vm.onFeedItemTapped = { [weak self] item in
            _ = self?.createDetailScreen(for: item)
        }
        let vc = UIHostingController(rootView: RSSFeedScreen(viewModel: vm))
        vc.setupTab(title: Localizable.home_tab_title.localized, image: "newspaper", selectedImage: "newspaper.fill")
        navigationController.pushViewController(vc, animated: false)
        return navigationController
    }
    
    private func createDetailScreen(for item: RSSFeedItemModel) -> UIViewController {
        let vm = RSSFeedItemDetailsViewModel(item: item)
        let vc = UIHostingController(rootView: RSSFeedItemDetailsScreen(viewModel: vm))
        navigationController.pushViewController(vc, animated: true)
        return vc
    }
}

