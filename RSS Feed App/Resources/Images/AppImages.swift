//
//  AppImages.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 12.03.2025..
//

import Foundation

enum AppImages: String {
    case no_image_placeholder_img = "no_image_placeholder_img"
}


extension AppImages {
    var image: String {
        String(rawValue)
    }
}
