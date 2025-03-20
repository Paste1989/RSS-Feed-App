//
//  PlaceholderModifier.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 19.03.2025..
//

import Foundation
import SwiftUICore

struct PlaceholderModifier: ViewModifier {
    var placeholder: String
    var isShowing: Bool
    var placeholderColor: Color

    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            content
            if isShowing {
                Text(placeholder)
                    .foregroundColor(placeholderColor)
                    .padding(.leading, 5)
                    .padding(.top, 8)
            }
        }
    }
}

extension View {
    func placeholder(when shouldShow: Bool, _ placeholder: String, color: Color = .gray) -> some View {
        self.modifier(PlaceholderModifier(placeholder: placeholder, isShowing: shouldShow, placeholderColor: color))
    }
}
