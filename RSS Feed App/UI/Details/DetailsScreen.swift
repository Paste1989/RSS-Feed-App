//
//  DetailsScreen.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import SwiftUI

struct DetailsScreen: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ZStack{
            AppColors.lightGrey.color.edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.rssItems) { feedItem in
                        
                        HStack(spacing: 0) {
                            AsyncImage(url: URL(string: feedItem.image ?? "")) { phase in
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
                            .padding(.horizontal, 10)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(feedItem.title)
                                    .font(.bodyMedium)
                                
                                Text(feedItem.description ?? "")
                                    .font(.bodySmall)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text(viewModel.channelTitle))
    }
}
    
    #Preview {
        DetailsScreen(viewModel: .init(rssService: ServiceFactory.rssService))
    }
