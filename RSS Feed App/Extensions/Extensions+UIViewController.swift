//
//  Extensions+UIViewController.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation
import UIKit

extension UIViewController {
    func setupTab(title: String, image: String, selectedImage: String) {
        self.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: image)?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.darkGray), selectedImage: UIImage(systemName: selectedImage)?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.darkText))
    }
}
