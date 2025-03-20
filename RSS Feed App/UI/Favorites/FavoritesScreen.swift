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
            
            //TODO: - Horzontal scroll (pager) for channels and feeds
            
            VStack(spacing: 0) {
                Text(Localizable.favorites_tab_title.localized)
                    .multilineTextAlignment(.center)
                    .font(.heading2)
                    .foregroundColor(AppColors.dark.color)
                    .padding(.bottom, 25)
                
                VStack(alignment: .leading, spacing: 15) {
                    Section {
                        Text(Localizable.channels_btn_title.localized)
                            .font(.bodyMedium)
                            .foregroundColor(AppColors.dark.color)
                            .padding(.leading, 15)
                        
                        if !viewModel.favoritesData.isEmpty {
                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVStack {
                                    ForEach(viewModel.favoritesData.indices, id: \.self) { i in
                                        FavoriteCellView(data: viewModel.favoritesData[i], onFavoriteTapped: {
                                            viewModel.favoriteTapped(data: viewModel.favoritesData[i], index: i)
                                        }) { channel in
                                            print("favorite channel tapped... \(channel.name)")
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            EmptyView()
                        }
                    }
                    
                    Section {
                        Text(Localizable.feed_items_title.localized)
                            .font(.bodyMedium)
                            .foregroundColor(AppColors.dark.color)
                            .padding(.leading, 15)
                        
                        //TODO: - Create feed items - Favorites
                        
                    }
                    Spacer()
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

