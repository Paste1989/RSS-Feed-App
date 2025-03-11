//
//  AppConfiguration.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation
import UIKit

struct AppConfiguration {
    private static let undefined = "n/a"
    
    static var environment: AppEnvironment {
        return AppEnvironment.current
    }
    
    static var bundleID: String {
        return Bundle.main.bundleIdentifier ?? undefined
    }
    
    static var appName: String {
        return configValue(key: "CFBundleName") ?? undefined
    }
    
    static var version: String {
        return configValue(key: "CFBundleShortVersionString") ?? undefined
    }
    
    static var buildNumber: String {
        return configValue(key: "CFBundleVersion") ?? undefined
    }
    
    static var baseURL: String {
        return configValue(key: "Base url") ?? undefined
    }
    
    static var googlePlistName: String {
        return configValue(key: "Google service name")!
    }
    
    static func configValue(key: String) -> String? {
        Bundle.main.object(forInfoDictionaryKey: key) as? String
    }
    
    static func versionOS() -> String {
        return UIDevice.current.systemVersion
    }
}

enum AppEnvironment: String {
    case dev = "dev"
    case staging = "staging"
    case live = "live"
    
    struct Constant {
        static let environmentKey = "ENVIRONMENT"
    }
    
    private static let defaultEnvironment = AppEnvironment.live
    
    private static var currentEnvironmentString: String? {
        return Bundle.main.object(forInfoDictionaryKey: Constant.environmentKey) as? String
    }
    
    static var current: AppEnvironment {
        guard let currentString = currentEnvironmentString else {
            return defaultEnvironment
        }
        
        switch currentString {
        case AppEnvironment.dev.rawValue:
            return .dev
        case AppEnvironment.staging.rawValue:
            return .staging
        case AppEnvironment.live.rawValue:
            return .live
        default:
            return defaultEnvironment
        }
    }
    
    static var isLive: Bool {
        return current == .live
    }
    
    static var currentEnvironment: String {
        return current.rawValue
    }
}
