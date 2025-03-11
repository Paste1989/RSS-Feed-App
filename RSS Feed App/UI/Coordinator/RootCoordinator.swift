//
//  RootCoordinator.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation
import UIKit
import SwiftUI

protocol Coordinator {
    func start() -> UIViewController
}

final class RootCoordinator: Coordinator {
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
        let homeCoordinator = HomeCoordinator()
        let favoritesCoordinator = FavoritesCoordinator()
        
        childCoordinators = [
            homeCoordinator,
            favoritesCoordinator
        ]
        
        tabbarController.tabBar.tintColor = UIColor.gray
        tabbarController.tabBar.backgroundColor = UIColor.white
        tabbarController.tabBar.unselectedItemTintColor = UIColor.darkGray
        tabbarController.viewControllers = childCoordinators.map { coordinator in
            return coordinator.start()
        }
        print("createTabbarController in startSplahScreen method")
 
        return tabbarController
    }
}
