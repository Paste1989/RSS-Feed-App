//
//  SplashViewModel.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation

class SplashViewModel: ObservableObject {
    var onSplashFinished: (() -> Void)?
    
    func startSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.onSplashFinished?()
        }
    }
}
