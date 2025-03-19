//
//  SplashScreen.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import SwiftUI

struct SplashScreen: View {
    @ObservedObject var viewModel: SplashViewModel
    var body: some View {
        ZStack {
            AppColors.white.color.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Text("RSS Feed App")
                    .font(.heading2)
                    .foregroundColor(AppColors.dark.color)
                    .padding(.bottom, 20)
                
                Image(AppImages.logo_img.image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(AppColors.primary.color)
                    .frame(width: 200, height: 200)
            }
        }
    }
}

#Preview {
    SplashScreen(viewModel: .init())
}
