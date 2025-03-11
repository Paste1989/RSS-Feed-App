//
//  HomeScreen.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import SwiftUI

struct HomeScreen: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        Text("Home VC" + "-" + "\(Localizable.news_title.localized)")
            .foregroundColor(AppColors.dark.color)
            .font(Font.heading2)
            .onTapGesture {
                viewModel.onTapped?()
            }
            .navigationBarTitle(Localizable.app_name.localized, displayMode: .automatic)
    }
}

#Preview {
    HomeScreen(viewModel: .init())
}
