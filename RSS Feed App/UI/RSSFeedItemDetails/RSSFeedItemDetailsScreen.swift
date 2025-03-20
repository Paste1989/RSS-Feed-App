//
//  RSSFeedItemDetailsScreen.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 19.03.2025..
//

import SwiftUI

struct RSSFeedItemDetailsScreen: View {
    @ObservedObject var viewModel: RSSFeedItemDetailsViewModel
    
    var body: some View {
        ZStack {
            AppColors.lightGrey.color.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                AsyncImage(
                    url: URL(string: viewModel.item?.image ?? ""),
                    content: { image in
                        image.resizable()
                    },
                    placeholder: {
                        Image(AppImages.no_image_placeholder_img.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: 200)
                            .foregroundColor(AppColors.disabled.color)
                    }
                )
                .frame(width: UIScreen.main.bounds.width, height: 200)
                .aspectRatio(contentMode: .fill)
                .padding(.bottom, 50)
                
                Text(viewModel.item?.title ?? "")
                    .multilineTextAlignment(.center)
                    .foregroundColor(AppColors.dark.color)
                    .font(.bodyXLarge)
                    .padding(.bottom, 15)
                    .padding(.horizontal, 20)
                
                Text(viewModel.item?.description ?? "")
                    .multilineTextAlignment(.leading)
                    .foregroundColor(AppColors.darkGrey.color)
                    .font(.bodyMedium)
                    .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 50)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.item?.title ?? "")
                    .foregroundColor(AppColors.dark.color)
                    .font(.heading2)
            }
        }
    }
}

#Preview {
    RSSFeedItemDetailsScreen(viewModel: .init())
}
