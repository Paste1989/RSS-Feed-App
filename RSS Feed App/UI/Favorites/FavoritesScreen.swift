//
//  FavoritesScreen.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import SwiftUI

struct FavoritesScreen: View {
    @ObservedObject var viewModel: FavoritesViewModel
    
    var body: some View {
        Text("Favorites VC")
            .foregroundColor(AppColors.dark.color)
            .font(Font.heading2)
    }
}

#Preview {
    FavoritesScreen(viewModel: .init())
}
