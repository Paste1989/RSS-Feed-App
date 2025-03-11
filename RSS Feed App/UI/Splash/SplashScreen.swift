//
//  SplashScreen.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import SwiftUI

struct SplashScreen: View {
    @ObservedObject var viewModel: SplashViewModel
    var body: some View {
        Text("Splash")
    }
}

#Preview {
    SplashScreen(viewModel: .init())
}
