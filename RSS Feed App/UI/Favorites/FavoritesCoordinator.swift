//
//  FavoritesCoordinator.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation
import UIKit
import SwiftUI

class FavoritesCoordinator: Coordinator {
    private let navigationController: UINavigationController = UINavigationController()
    
    func start() -> UIViewController {
        let vm = FavoritesViewModel(persistenceService: ServiceFactory.persistenceService, favoriteService: ServiceFactory.favoriteService)
        let vc = UIHostingController(rootView: FavoritesScreen(viewModel: vm))
        vc.setupTab(title: Localizable.favorites_tab_title.localized, image: "heart", selectedImage: "heart.fill")
        self.navigationController.pushViewController(vc, animated: false)
        return vc
    }
}
