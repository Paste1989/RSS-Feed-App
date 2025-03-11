//
//  DetailsScreen.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import SwiftUI

struct DetailsScreen: View {
    @ObservedObject var viewModel: DetailsViewModel
    
    var body: some View {
        Text("Details VC")
    }
}

#Preview {
    DetailsScreen(viewModel: .init())
}
