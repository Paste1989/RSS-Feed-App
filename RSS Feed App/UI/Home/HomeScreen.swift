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
        Text("Home VC")
            .onTapGesture {
                viewModel.onTapped?()
            }
    }
}

#Preview {
    HomeScreen(viewModel: .init())
}
