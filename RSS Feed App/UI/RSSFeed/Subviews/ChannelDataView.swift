//
//  ChannelDataView.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 19.03.2025..
//

import SwiftUI

struct ChannelDataView: View {
    @Environment(\.presentationMode) var presentationMode
    var viewModel: RSSFeedViewModel
    init(viewModel: RSSFeedViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 10) {
                ForEach(Array(viewModel.rssChannels.enumerated()), id: \.offset) { index, channel in
                    ChannelCellView(channel: channel, onFavoriteTapped: {
                        viewModel.favoriteTapped(data: channel, index: index)
                    })
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        viewModel.fetchFeed(for: channel)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding(.bottom, 5)
                    
                    Divider()
                }
            }
        }
    }
}

#Preview {
    ChannelDataView(viewModel: .init(persistenceService: ServiceFactory.persistenceService, rssService: ServiceFactory.rssService, connectivityService: ServiceFactory.connectivityService, channelsDataService: ServiceFactory.rssChannelsDataService, favoriteService: ServiceFactory.favoriteService))
}


struct ChannelCellView: View {
    var channel: RSSChannelModel
    var onFavoriteTapped: (() -> Void)?
    @State var isFavorite = Bool()
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: channel.image ?? "")) { phase in
                switch phase {
                case .empty:
                    Image(AppImages.no_image_placeholder_img.image)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(AppColors.disabled.color)
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .clipped()
                    
                case .failure:
                    Image(AppImages.no_image_placeholder_img.image)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(AppColors.disabled.color)
                    
                @unknown default:
                    ProgressView()
                        .frame(height: 120)
                        .background(AppColors.disabled.color)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .symbolRenderingMode(.palette)
                        .frame(width: 20, height: 20)
                        .foregroundColor(isFavorite ? AppColors.primary.color : AppColors.lightGrey.color)
                        .background(AppColors.white.color
                            .frame(width: 35, height:  35)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(AppColors.darkGrey.color, lineWidth: 2))
                                .cornerRadius(5))
                        .onTapGesture {
                            isFavorite.toggle()
                            onFavoriteTapped?()
                        }
                        .padding(.all,10)
                    Spacer()
                }
                
                Spacer()
                
                HStack(spacing: 0) {
                    Spacer()
                    Text(channel.name)
                        .frame(maxWidth: 200)
                        .font(.bodyXLarge)
                        .foregroundColor(AppColors.dark.color)
                        .padding(7)
                        .background(AppColors.lightGrey.color)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(AppColors.dark.color, lineWidth: 2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .offset(x: -10, y: -10)
                }
            }
        }
        .onAppear {
            isFavorite = ServiceFactory.favoriteService.isFavorite(data: channel)
        }
    }
}
