//
//  HomeCoordinator.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation
import UIKit
import SwiftUI

class HomeCoordinator: Coordinator {
    private let navigationController: UINavigationController = UINavigationController()

    func start() -> UIViewController {
        createHomeScreen()
    }
    
    private func createHomeScreen() -> UIViewController {
        let vm = HomeViewModel(rssService: ServiceFactory.rssService)
        vm.onChannelTapped = { [weak self] channel in
            _ = self?.createDetailsScreen(channel: channel)
        }
        let vc = UIHostingController(rootView: HomeScreen(viewModel: vm))
        vc.setupTab(title: Localizable.home_tab_title.localized, image: "house", selectedImage: "house.fill")
        navigationController.pushViewController(vc, animated: false)
        return navigationController
    }
    
    private func createDetailsScreen(channel: RSSChannel) -> UIViewController {
        let vm = HomeViewModel(rssService: ServiceFactory.rssService)
        vm.fetchFeed(for: channel)
        let vc = UIHostingController(rootView: DetailsScreen(viewModel: vm))
        self.navigationController.pushViewController(vc, animated: true)
        return navigationController
    }
}

