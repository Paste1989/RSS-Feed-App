//
//  AppColors.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation
import SwiftUI

enum AppColors: String {
    case primary = "PrimaryGreen"
    case white = "WhiteCold"
    case dark = "Dark"
    case darkGrey = "DarkGrey"
    case lightGrey = "LightGrey"
    case success = "Sucsess"
    case error = "Error"
    case disabled = "Disabled"
}

extension AppColors {
    var color: Color {
        Color(rawValue)
    }
}

