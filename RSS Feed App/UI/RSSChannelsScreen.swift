//
//  RSSChannelsScreen.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 12.03.2025..
//

import SwiftUI

struct RSSChannelsScreen: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            AppColors.lightGrey.color.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack(spacing: 0){
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle")
                            .font(.bodyXLarge)
                            .foregroundColor(AppColors.dark.color)
                            .frame(width: 40, height: 40)      
                    }
                    .padding(10)
                }
                
                VStack(spacing: 0) {
                    Text(Localizable.rss_chanells_title.localized)
                        .font(.heading2)
                        .foregroundColor(AppColors.dark.color)
                    
                    Spacer()
                    
                    switch viewModel.state {
                    case .success:
                        ScrollView(showsIndicators: false) {
                            LazyVStack(alignment: .leading, spacing: 12) {
                                ForEach(viewModel.rssChannels) { channel in
                                    HStack(spacing: 12) {
                                        AsyncImage(url: URL(string: channel.image ?? "")) { phase in
                                            switch phase {
                                            case .empty:
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 60, height: 60)
                                                    .foregroundColor(AppColors.disabled.color)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                                
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 60, height: 50)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                                
                                            case .failure:
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 60, height: 60)
                                                    .foregroundColor(AppColors.disabled.color)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                                
                                            @unknown default:
                                                ProgressView()
                                                    .frame(width: 60, height: 60)
                                                    .background(Color.gray.opacity(0.3))
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                            }
                                        }
                                        .padding(.horizontal, 5)
                                        
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(channel.name)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                        }
                                    }
                                    .onTapGesture {
                                        viewModel.fetchFeed(for: channel)
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                    .padding(.vertical, 8)
                                }
                            }
                        }
                        
                    case .error:
                        Text(Localizable.error_enter_valid_url.localized)
                            .font(.bodyXLarge)
                            .foregroundColor(AppColors.error.color)
                        
                    case .loading:
                        ProgressView {
                            Text(Localizable.loading_state_title.localized)
                                .font(.bodyLarge)
                                .foregroundColor(AppColors.darkGrey.color)
                                .bold()
                        }
                        .foregroundColor(AppColors.dark.color)
                        
                    case .none:
                        EmptyView()
                    }
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .task {
                if !viewModel.fetched {
                    viewModel.fetchRSSChannels()
                }
            }
        }
    }
}

#Preview {
    RSSChannelsScreen(viewModel: .init(rssService: ServiceFactory.rssService))
}
