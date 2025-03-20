//
//  RSSFeedCellView.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 19.03.2025..
//

import SwiftUI

struct RSSFeedCellView: View {
    var feedItem: RSSFeedItemModel
    
    var body: some View {
        HStack(spacing: 12) {
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
                    .padding(.bottom, 10)
                                
                HStack(spacing: 0) {
                    Spacer()
                    Link(destination: URL(string: feedItem.link)!) {
                        Text(Localizable.read_more_title.localized)
                            .foregroundColor(AppColors.dark.color)
                            .font(Font.labelSmall)
                            .padding(.trailing, 5)
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(AppColors.dark.color)
                            .font(.labelMedium)
                            .padding(.trailing, 10)
                    }
                }
            }
        }
        .padding(.vertical, 10)
        
        Divider()
    }
}

#Preview {
    RSSFeedCellView(feedItem: RSSFeedItemModel(id: UUID(), title: "", description: "", image: "", link: ""))
}


