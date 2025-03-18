//
//  RSSChannelsScreen.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 12.03.2025..
//

import SwiftUI

struct RSSChannelsScreen: View {
    @ObservedObject var viewModel: RSSFeedViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var isShown: Bool = false
    
    var body: some View {
        ZStack{
            AppColors.white.color.edgesIgnoringSafeArea(.all)
            
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
                }
                
                VStack(spacing: 0) {
                    Text(Localizable.rss_chanells_title.localized)
                        .font(.heading2)
                        .foregroundColor(AppColors.dark.color)
                    
                    Spacer()
                    
                    switch viewModel.state {
                    case .success:
                        ChannelDataView(viewModel: viewModel) 
                    case .error(let type):
                        switch type {
                        case .channel:
                            if viewModel.checkInternetConnection() {
                                Text(Localizable.error_enter_valid_url.localized)
                                    .font(.bodySmall)
                                    .foregroundColor(AppColors.error.color)
                            }
                            else {
                                
                                ZStack{}
                                    .onAppear {
                                        isShown = true
                                    }
                            }
                        case .feed:
                            ChannelDataView(viewModel: viewModel)
                        }
                    case .loading:
                            ProgressView {
                                Text(Localizable.loading_state_title.localized)
                                    .font(.bodyLarge)
                                    .foregroundColor(AppColors.darkGrey.color)
                                    .bold()
                            }
                            .tint(AppColors.dark.color)
                            .foregroundColor(AppColors.dark.color)
                    
                        
                    case .none:
                        EmptyView()
                    }
                    
                    Spacer()
                }
            }
            .overlay(
                CustomModalView(modalType: .twoButtonsAlert, cancelButtonTitle: "Cancel", confirmButtonTitle: "OK", title: "Internet connection failed", message: "Please check your Internet connection.", cancelButtonShow: false, hasDescription: true, onConfirmButtonTapped: { [weak viewModel] in
                    isShown = false
                })
                    .opacity(isShown ? 1 : 0)
            )
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    RSSChannelsScreen(viewModel: .init(persistenceService: ServiceFactory.persistenceService, rssService: ServiceFactory.rssService, connectivityService: ServiceFactory.connectivityService))
}



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
