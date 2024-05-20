//
//  NotificationCell.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26/11/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import SwiftUI

struct NotificationCell: View {
    
    var notification: NotificationModel!
    @State private var offsetX: CGFloat = .zero
    @State private var showTrash = false
    var deleteHandler: CHMStringBlock?

    var body: some View {
        ZStack {
            if showTrash {
                Button {
                    withAnimation {
                        offsetX = -400
                        showTrash = false
                        deleteHandler?(notification.id)
                    }
                } label: {
                    Image(systemName: "trash")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.foreground)
                        .frame(width: 30)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 30)
                }
            }
            
            NotificationCellView
                .offset(x: offsetX)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            if offsetX > -16 || -offsetX > Constants.maxOffsetX { return }
                            withAnimation {
                                offsetX = value.translation.width
                            }
                        })
                        .onEnded({ value in
                            if -value.translation.width > Constants.maxOffsetX {
                                withAnimation {
                                    offsetX = -Constants.maxOffsetX
                                    showTrash = true
                                }
                            }
                            if -value.translation.width < 5 {
                                showTrash = false
                                withAnimation {
                                    offsetX = .zero
                                }
                            }
                        })
                )
        }
    }
}

// MARK: - Views

private extension NotificationCell {
    
    var NotificationCellView: some View {
        HStack(alignment: .center, spacing: 24) {
            VStack {
                Text(notification.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                
                Text(notification.date)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 12, weight: .medium, design: .serif))
                
                if let message = notification.text {
                    Text(message)
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 3)
                }
            }
        }
        .padding()
        .background(Constants.notificationBgColor)
        .clipShape(.rect(cornerRadius: 16))
        .padding(.horizontal)
    }
    
    var BackgroundView: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.red)
    }
}

// MARK: - Preview

#Preview {
    NotificationCell(notification: .mockData) { id in
        print("delete: \(id)")
    }
}

// MARK: - Constants

private extension NotificationCell {

    enum Constants {
        static let topLineColor = LinearGradient(
            colors: [.blue, .blue, .clear],
            startPoint: .leading,
            endPoint: .trailing
        )
        static let notificationBgColor = CHMColor<BackgroundPalette>.bgCommentView.color
        static var maxOffsetX: CGFloat = 80
    }
}
