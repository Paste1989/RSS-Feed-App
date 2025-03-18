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
                    TextField(Localizable.enter_url_placeholder.localized, text: $inputText)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .foregroundColor(AppColors.white.color)
                    
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
                            print("remove tapped")
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
                            
                            //.padding(.vertical, 20)
                            
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
                                
                                //.padding(20)
                            }
                            .padding(.horizontal, 5)
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 15)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Text(viewModel.channelTitle)
                            .foregroundColor(AppColors.dark.color)
                            .font(.bodyXLarge)
                            .padding(.vertical, 20)
                        
                        switch viewModel.state {
                        case .success:
                            LazyVStack(alignment: .leading, spacing: 12) {
                                ForEach(viewModel.rssFeedItems) { feedItem in
                                    HStack(spacing: 12) {
                                        Link(destination: URL(string: feedItem.link)!) {
                                            AsyncImage(url: URL(string: feedItem.image!)) { phase in
                                                switch phase {
                                                case .empty:
                                                    Image(AppImages.no_image_placeholder_img.image)
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
                                                    Image(AppImages.no_image_placeholder_img.image)
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
                                            .padding(.horizontal, 15)
                                            
                                            
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text(feedItem.title)
                                                    .font(Font.labelLarge)
                                                    .foregroundColor(AppColors.dark.color)
                                                    .multilineTextAlignment(.leading)
                                                
                                                Text(feedItem.description ?? "")
                                                    .font(Font.labelMedium)
                                                    .foregroundColor(AppColors.darkGrey.color)
                                                    .multilineTextAlignment(.leading)
                                                
                                                HStack(spacing: 0) {
                                                    Spacer()
                                                    
                                                    Text(Localizable.read_more_title.localized)
                                                        .foregroundColor(AppColors.darkGrey.color)
                                                        .font(Font.labelSmall)
                                                        .padding(.trailing, 10)
                                                }
                                            }
                                        }
                                    }
                                    .onTapGesture {
                                        print("tapped...")
                                    }
                                    .padding(.vertical, 10)
                                    
                                    Divider()
                                }
                            }
                        case .error:
                            if viewModel.checkInternetConnection() {
                                Text(Localizable.error_enter_valid_url.localized)
                                    .font(.bodySmall)
                                    .foregroundColor(AppColors.error.color)
                            }
                            else {
                                Text("No internet connection")
                                    .onAppear {
                                        isShown = true
                                    }
                            }
                        default:
                            EmptyView()
                            
                        }
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 10)
            .overlay(
                CustomModalView(modalType: .twoButtonsAlert, cancelButtonTitle: "Cancel", confirmButtonTitle: "OK", title: "Internet connection failed", message: "Please check your Internet connection.", cancelButtonShow: false, hasDescription: true, onConfirmButtonTapped: { [weak viewModel] in
                    isShown = false
                })
                .opacity(isShown ? 1 : 0)
            )
            .sheet(isPresented: $rssChanelsScreenShown, onDismiss: {
                rssChanelsScreenShown = false
                inputText = viewModel.channelURL
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
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    print("channels tapped")
                    rssChanelsScreenShown.toggle()
                }) {
                    Text(Localizable.channels_btn_title.localized)
                        .foregroundColor(AppColors.dark.color)
                        .font(.bodyMedium)
                }
            })
            .task {
                viewModel.getChannelsfromStorage()
                if !viewModel.isInitalDataFetched() {
                    viewModel.fetchRSSChannels()
                }
                
                viewModel.getFeedItemsfromStorage()
            }
        }
    }
}
