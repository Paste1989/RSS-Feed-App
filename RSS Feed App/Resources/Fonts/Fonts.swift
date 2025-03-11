//
//  AppFonts.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 11.03.2025..
//

import Foundation
import SwiftUI

extension Font {
    struct Constants {
        static let tiemposRegular = "TestTiemposFine-Regular"
        static let maisonNeueDemi = "MaisonNeue-Demi"
    }
    
    //Heading
    static let heading1 = Font.custom(Constants.tiemposRegular, fixedSize: 48)
    static let heading2 = Font.custom(Constants.tiemposRegular, fixedSize: 24)
    
    //Body
    static let bodyXLarge = Font.custom(Constants.maisonNeueDemi, size: 18)
    static let bodyLarge = Font.custom(Constants.maisonNeueDemi, size: 16)
    static let bodyMedium = Font.custom(Constants.maisonNeueDemi, size: 14)
    static let bodySmall = Font.custom(Constants.maisonNeueDemi, size: 12)
    
    //Label
    static let labelLarge = Font.custom(Constants.maisonNeueDemi, size: 14)
    static let labelMedium = Font.custom(Constants.maisonNeueDemi, size: 12)
    static let labelSmall = Font.custom(Constants.maisonNeueDemi, size: 10)
}
