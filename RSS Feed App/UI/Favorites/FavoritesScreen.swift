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
        ZStack {
            AppColors.lightGrey.color.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Text(Localizable.favorites_tab_title.localized)
                    .font(.heading2)
                    .foregroundColor(AppColors.dark.color)
                    .padding(.bottom, 25)
                
                if !viewModel.favoritesData.isEmpty {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack {
                            ForEach(viewModel.favoritesData.indices, id: \.self) { i in
                                FavoriteCellView(data: viewModel.favoritesData[i], onFavoriteTapped: {
                                    viewModel.favoriteTapped(data: viewModel.favoritesData[i], index: i)
                                })
                            }
                        }
                    }
                }
                else {
                    EmptyView()
                }
            }
        }
        .onAppear {
            viewModel.favoritesData = viewModel.getAllFavoriteChannels()
        }
    }
}

#Preview {
    FavoritesScreen(viewModel: .init(persistenceService: ServiceFactory.persistenceService, favoriteService: ServiceFactory.favoriteService))
}

