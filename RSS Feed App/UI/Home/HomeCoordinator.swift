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
        let vm = HomeViewModel()
        vm.onTapped = { [weak self] in
            _ = self?.createFavoritesScreen()
        }
        let vc = UIHostingController(rootView: HomeScreen(viewModel: vm))
        vc.setupTab(title: "Home", image: "house", selectedImage: "house.fill")
        navigationController.pushViewController(vc, animated: false)
        return navigationController
    }
    
    private func createFavoritesScreen() -> UIViewController {
        let vm = DetailsViewModel()
        let vc = UIHostingController(rootView: DetailsScreen(viewModel: vm))
        self.navigationController.pushViewController(vc, animated: true)
        return navigationController
    }
}

