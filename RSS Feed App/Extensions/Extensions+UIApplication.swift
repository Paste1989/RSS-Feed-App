//
//  Extensions+UIApplication.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 19.03.2025..
//

import Foundation
import UIKit

extension UIApplication {
    var currentKeyWindow: UIWindow? {
        self.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
