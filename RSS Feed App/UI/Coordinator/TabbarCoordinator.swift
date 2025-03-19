//
//  TabbarCoordinator.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 19.03.2025..
//

import Foundation
import UIKit

final class TabbarCoordinator: Coordinator {
    private let navigationController: UINavigationController = UINavigationController()
    var tabbarController = UITabBarController()
    var childCoordinators = [Coordinator]()
    
    func start() -> UIViewController {
        return startTabBarController()
    }
    
    private func startTabBarController() -> UIViewController {
        let vc = createTabbarController()
        return vc
    }
    
    private func createTabbarController() -> UIViewController {
        let homeCoordinator = RSSFeedCoordinator()
        let favoritesCoordinator = FavoritesCoordinator()
        
        childCoordinators = [
            homeCoordinator,
            favoritesCoordinator
        ]
        
        tabbarController.tabBar.tintColor = UIColor(AppColors.darkGrey.color)
        tabbarController.tabBar.backgroundColor = UIColor(AppColors.white.color)
        tabbarController.tabBar.unselectedItemTintColor = UIColor(AppColors.disabled.color)
        tabbarController.viewControllers = childCoordinators.map { coordinator in
            return coordinator.start()
        }
 
        return tabbarController
    }
}
