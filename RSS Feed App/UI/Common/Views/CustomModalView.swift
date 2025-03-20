//
//  CustomModalView.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 14.03.2025..
//

import Foundation
import SwiftUICore
import SwiftUI

enum ModalType {
    case oneButtonAlert
    case twoButtonsAlert
}

struct CustomModalView: View {
    var modalType: ModalType
    var cancelButtonTitle: String
    var confirmButtonTitle: String
    var confirmationButtonColor: Color = AppColors.primary.color
    var title: String
    var message: String
    var cancelButtonShow: Bool
    var hasDescription: Bool
    var onConfirmButtonTapped: (() -> Void)?
    var onCancelButtonTapped: (() -> Void)?

    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                VStack(alignment: .center, spacing: 0) {
                    Text(title)
                        .font(.bodySmall)
                        .multilineTextAlignment(.center)
                        .foregroundColor(AppColors.dark.color)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    if hasDescription {
                        Text("\(message)")
                            .font(.bodyMedium)
                            .multilineTextAlignment(.center)
                            .foregroundColor(AppColors.dark.color)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 20)
                    }
                }
                
                HStack(spacing: 0) {
                    if cancelButtonShow {
                        Button {
                            print("* Cancel tapped")
                            onCancelButtonTapped?()
                            
                        } label: {
                            Text(cancelButtonTitle)
                                .frame(maxWidth: .infinity)
                                .font(.bodySmall)
                                .foregroundColor(AppColors.white.color)
                                .background(AppColors.disabled.color)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .background(AppColors.disabled.color)
                        .border(AppColors.white.color)
                        .cornerRadius(2)
                        .padding(.leading, 24)
                        .padding(.trailing, 5)
                        .padding(.bottom, 24)
                    }
                    
                    Button {
                        print("confirm")
                        onConfirmButtonTapped?()
                    } label: {
                        Text(confirmButtonTitle)
                            .frame(maxWidth: .infinity)
                            .font(.bodySmall)
                            .foregroundColor(AppColors.white.color)
                            .background(AppColors.primary.color)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(confirmationButtonColor)
                    .cornerRadius(2)
                    .padding(.leading, 24)
                    .padding(.trailing, 24)
                    .padding(.bottom, 24)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(AppColors.white.color)
            .cornerRadius(4)
            .shadow(color: AppColors.darkGrey.color, radius: 10, y: 4)
        }
    
    }
}

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomModalView(modalType: .oneButtonAlert, cancelButtonTitle: "", confirmButtonTitle: "", title: "", message: "", cancelButtonShow: false, hasDescription: true)
    }
}
