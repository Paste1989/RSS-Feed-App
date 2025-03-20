//
//  HomeScreen.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import SwiftUI
import UIKit

struct RSSFeedScreen: View {
    @ObservedObject var viewModel: RSSFeedViewModel
    @State var inputText: String = ""
    @State var rssChanelsScreenShown: Bool = false
    @State var isShown: Bool = false
    
    var body: some View {
        ZStack{
            AppColors.lightGrey.color.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    TextField("", text: $inputText)
                        .frame(width: UIScreen.main.bounds.width - 100)
                        .padding(10)
                        .background(AppColors.white.color)
                        .foregroundColor(AppColors.darkGrey.color)
                        .placeholder(when: inputText.isEmpty, Localizable.enter_url_placeholder.localized, color: AppColors.darkGrey.color)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                        .accentColor(AppColors.dark.color)
                        .padding()
                    
                    Button {
                        viewModel.fetchFeed(with: inputText)
                    } label: {
                        Image(systemName: "arrow.right")
                            .foregroundColor(AppColors.dark.color)
                            .font(.bodyXLarge)
                    }
                }
                
                HStack(spacing: 0) {
                    if !viewModel.channels.isEmpty {
                        Button {
                            Task {
                                await viewModel.removeFeedItemsFromStorage()
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .frame(width: 50, height: 50)
                                .foregroundColor(AppColors.dark.color)
                                .font(.bodyLarge)
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(viewModel.channels) { channel in
                                VStack(spacing: 0) {
                                    Text(channel.name)
                                        .foregroundColor(viewModel.currentChannel == channel ? AppColors.white.color : AppColors.dark.color)
                                        .font(.bodyLarge)
                                }
                                .padding(7)
                                .background(viewModel.currentChannel == channel ? AppColors.primary.color : AppColors.white.color)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .onTapGesture {
                                    viewModel.fetchFeed(for: channel)
                                    inputText = channel.link
                                }
                            }
                            .padding(.horizontal, 5)
                        }
                    }
                }
                .opacity(viewModel.rssFeedItems.isEmpty ? 0 : 1)
                .padding(.horizontal, 10)
                .padding(.bottom, viewModel.rssFeedItems.isEmpty ? 0 : 15)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Text(viewModel.currentChannel?.name ?? "")
                            .foregroundColor(AppColors.dark.color)
                            .font(.bodyXLarge)
                        
                        switch viewModel.state {
                        case .success:
                            LazyVStack(alignment: .leading, spacing: 12) {
                                ForEach(viewModel.rssFeedItems) { feedItem in
                                    RSSFeedCellView(feedItem: feedItem)
                                        .onTapGesture {
                                            viewModel.onFeedItemTapped?(feedItem)
                                        }
                                }
                            }
                        case .error:
                            Text(Localizable.error_enter_valid_url.localized)
                                .font(.bodySmall)
                                .foregroundColor(AppColors.error.color)
                        default:
                            EmptyView()
                            
                        }
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 10)
            .overlay(
                CustomModalView(modalType: .oneButtonAlert, cancelButtonTitle: Localizable.cancel_button_title.localized, confirmButtonTitle: Localizable.ok_button_title.localized, title: Localizable.internet_connection_failure_title.localized, message: Localizable.internet_connection_failure_description.localized, cancelButtonShow: false, hasDescription: true, onConfirmButtonTapped: {
                    viewModel.isConnected = true
                })
                .opacity(viewModel.isConnected ? 0 : 1)
            )
            .sheet(isPresented: $rssChanelsScreenShown, onDismiss: {
                rssChanelsScreenShown = false
                inputText = viewModel.currentChannel?.link ?? ""
            }) {
                RSSChannelsScreen(viewModel: viewModel)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(Localizable.app_name.localized)
                        .font(.heading2)
                        .foregroundColor(AppColors.dark.color)
                }
            }
            .navigationBarItems(
                leading: Image(AppImages.logo_img.image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(AppColors.primary.color)
                    .frame(width: 44, height: 44),
                
                trailing: HStack {
                    Button(action: {
                        rssChanelsScreenShown.toggle()
                    }) {
                        Text(Localizable.channels_btn_title.localized)
                            .foregroundColor(AppColors.dark.color)
                            .font(.bodyMedium)
                    }
                }
            )
            .task {
                viewModel.getChannelsfromStorage()
                viewModel.getFeedItemsfromStorage()
                
                if !viewModel.isInitalDataFetched() {
                    viewModel.fetchRSSChannels()
                }
            }
        }
    }
}

