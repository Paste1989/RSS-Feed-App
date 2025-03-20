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
    private var childCoordinator: Coordinator?
    private var navigationController: UINavigationController = UINavigationController()
    
    func start() -> UIViewController {
        return createSplashViewController()
    }
   
    private func createSplashViewController() -> UIViewController {
        let vm = SplashViewModel()
            vm.startSplash()
            vm.onSplashFinished = { [weak self] in
                _ = self?.createTabbarViewController()
            }
        let vc = UIHostingController(rootView: SplashScreen(viewModel: vm))
        navigationController.pushViewController(vc, animated: false)
        return vc
    }
    
    private func createTabbarViewController() -> UIViewController {
        let tabbarCoordinator = TabbarCoordinator()
        childCoordinator = tabbarCoordinator
        let tabbarController = tabbarCoordinator.start()
        UIApplication.shared.currentKeyWindow?.rootViewController = tabbarController
        return tabbarController
    }
}
