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
                ForEach(viewModel.rssChannels) { channel in
                    
                    ZStack(alignment: .bottomTrailing) {
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
                        
                        Text(channel.name)
                            .frame(maxWidth: 200)
                            .font(.bodyXLarge)
                            .foregroundColor(AppColors.dark.color)
                            .padding(7)
                            .background(AppColors.lightGrey.color)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .offset(x: -10, y: -10)
                    }
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
    ChannelDataView(viewModel: .init(persistenceService: ServiceFactory.persistenceService, rssService: ServiceFactory.rssService, connectivityService: ServiceFactory.connectivityService))
}
