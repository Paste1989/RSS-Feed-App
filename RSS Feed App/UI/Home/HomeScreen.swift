//
//  HomeScreen.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import SwiftUI
import UIKit

struct HomeScreen: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ZStack{
            AppColors.lightGrey.color.edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    Spacer()
                    
                    switch viewModel.state {
                    case .success:
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(viewModel.rssChannels) { channel in
                                HStack(spacing: 12) {
                                    AsyncImage(url: URL(string: channel.image ?? "")) { phase in
                                        switch phase {
                                        case .empty:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 55, height: 55)
                                                .background(Color.gray.opacity(0.3))
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 60, height: 60)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 55, height: 55)
                                                .background(Color.gray.opacity(0.3))
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
                                    viewModel.onChannelTapped?(channel)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    case .error:
                        Text("Error occured. Please try again later.")
                            .font(.bodyXLarge)
                            .foregroundColor(AppColors.error.color)
                        
                    case .loading:
                        ProgressView {
                            Text("Loading...")
                                .foregroundColor(AppColors.darkGrey.color)
                                .bold()
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .navigationBarTitle(Text("RSS Channels"), displayMode: .automatic)
            .task {
                if !viewModel.fetched {
                    viewModel.fetchRSSChannels()
                }
            }
        }
    }
}

