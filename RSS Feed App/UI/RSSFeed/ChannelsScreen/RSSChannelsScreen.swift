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
                    .padding(.top, 10)
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
                CustomModalView(modalType: .twoButtonsAlert, cancelButtonTitle: "Cancel", confirmButtonTitle: "OK", title: "Internet connection failed", message: "Please check your Internet connection.", cancelButtonShow: false, hasDescription: true, onConfirmButtonTapped: {
                    isShown = false
                })
                    .opacity(isShown ? 1 : 0)
            )
            .padding(.horizontal, 20)
        }
        .overlay(
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 0){
                    Spacer()
                    HStack(spacing: 0) {
                        Spacer()
                        Button(action: {
                            Task {
                                await viewModel.reloadChannels()
                            }
                        }) {
                            VStack(spacing: 10) {
                                Image(systemName: "arrow.down.doc")
                                    .font(.bodyXLarge)
                                    .foregroundColor(AppColors.dark.color)
                                    .frame(width: 60, height: 60)
                            }
                            .background(AppColors.primary.color)
                            .clipShape(Circle())
                            .shadow(color: AppColors.darkGrey.color, radius: 10, y: 4)
                        }
                        .frame(width: 70, height: 70)
                        .padding(25)
                    }
                }
            }
        )
    }
}

#Preview {
    RSSChannelsScreen(viewModel: .init(persistenceService: ServiceFactory.persistenceService, rssService: ServiceFactory.rssService, connectivityService: ServiceFactory.connectivityService))
}
