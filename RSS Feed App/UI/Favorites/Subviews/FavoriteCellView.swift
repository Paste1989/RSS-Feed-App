//
//  FavoriteCellView.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 19.03.2025..
//

import SwiftUI

struct FavoriteCellView: View {
    var data: RSSChannelModel
    var onFavoriteTapped: (() -> Void)?
    var onItemTapped: ((RSSChannelModel) -> Void)?
    
    var body: some View {
        ZStack {
            AppColors.white.color.edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .topLeading) {
                HStack( spacing: 0) {
                    AsyncImage(
                        url: URL(string: data.image ?? ""),
                        content: { image in
                            image.resizable()
                        },
                        placeholder: {
                            Image(AppImages.no_image_placeholder_img.image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 95)
                                .foregroundColor(AppColors.disabled.color)
                        }
                    )
                    .frame(width: 150, height: 95)
                    .aspectRatio(contentMode: .fill)
                    
                    VStack(spacing: 0) {
                        Text(data.name)
                            .font(.bodyLarge)
                            .foregroundColor(AppColors.dark.color)
                            .padding(.bottom, 5)
                        
                        Text(data.link)
                            .font(.bodySmall)
                            .foregroundColor(AppColors.darkGrey.color)
                    }
                    .padding(.leading, 5)
                    
                    Spacer()
                }
                
                HStack(spacing: 0) {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .symbolRenderingMode(.palette)
                        .frame(width: 20, height: 20)
                        .foregroundColor(ServiceFactory.favoriteService.isFavorite(data: data) ? AppColors.primary.color : AppColors.lightGrey.color)
                        .background(AppColors.white.color
                            .frame(width: 35, height:  35)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(AppColors.darkGrey.color, lineWidth: 2))
                                .cornerRadius(5))
                        .onTapGesture {
                            onFavoriteTapped?()
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                }
            }
        }
        .frame(height: 100)
        .cornerRadius(10)
        .padding(.horizontal, 10)
        .onTapGesture {
            onItemTapped?(data)
        }
    }
}

struct FavoriteCell_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteCellView(data: RSSChannelModel(id: UUID(), name: "", image: "", link: ""))
    }
}
