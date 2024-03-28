//
//  ChatSubviews.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 27.03.2024.
//

import SwiftUI


// MARK: - Subviews

extension ChatView {

    var MainView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ScrollView {
                    MessagesBlock
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
                    )
                }

                TextFieldBlock
                    .padding(.vertical, 6)
                    .background(Constants.bottomBackgroundColor)
            }
            .frame(maxHeight: .infinity)
            .onChange(of: viewModel.lastMessageID) { _, id in
                if let id {
                    withAnimation {
                        proxy.scrollTo(id, anchor: .bottom)
                    }
                }
            }
            .background {
                BackgroundView
                    .ignoresSafeArea()
            }
        }
        .onDisappear(perform: viewModel.quitChat)
    }

    var MessagesBlock: some View {
        LazyVStack {
            ForEach(viewModel.messages) { message in
                switch message.kind {
                case .bubble:
                    MessageBubble(message: message)
                        .padding(.horizontal, 8)

                case .join:
                    MessageJoinText(
                        userName: Constants.joinChatMessage(userName: message.userName)
                    )

                case .quit:
                    MessageJoinText(
                        userName: Constants.quitChatMessage(userName: message.userName)
                    )
                }
            }
        }
        .padding(.bottom, 50)
    }

    var BackgroundView: some View {
        LinearGradient(
            colors: Constants.gradientBackgroundColor,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .mask {
            Constants.tgBackground
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    var TextFieldBlock: some View {
        HStack {
            Constants.paperClip

            TextField(Constants.placeholder, text: $messageText)
                .padding(.vertical, 6)
                .padding(.horizontal, 13)
                .background(Constants.textFieldBackgroundColor, in: .rect(cornerRadius: 20))
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 1)
                        .fill(Constants.textFieldStrokeColor)
                }

            if messageText.isEmpty {
                Constants.record
                    .frame(width: 22, height: 22)

            } else {
                Button {
                    viewModel.sendMessage(message: messageText)
                    messageText = .clear
                } label: {
                    Image(systemName: Constants.paperplane)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                        .foregroundStyle(Constants.iconColor)
                }
            }
        }
        .padding(.horizontal, 8)
    }

    func MessageJoinText(userName: String) -> some View {
        Text(userName)
            .font(.caption)
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(.black.opacity(0.7), in: .capsule)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
}

// MARK: - Constants

private extension ChatView {

    enum Constants {
        static let imageSize: CGFloat = 200
        static let imageCornerRadius: CGFloat = 20
        static let textColor: Color = CHMColor<TextPalette>.textPrimary.color
        static let tgBackground = Image("tg_layer")
        static let paperClip = Image("paperClip")
        static let record = Image("record")
        static let messageBackgroundColor = Color(red: 103/255, green: 77/255, blue: 122/255)
        static let textFieldBackgroundColor = Color(red: 6/255, green: 6/255, blue: 6/255)
        static let textFieldStrokeColor = Color(red: 58/255, green: 58/255, blue: 60/255)
        static let bottomBackgroundColor = Color(red: 28/255, green: 28/255, blue: 29/255)
        static let iconColor = Color(red: 127/255, green: 127/255, blue: 127/255)
        static let placeholder = "Message"
        static let paperplane = "paperplane"
        static func joinChatMessage(userName: String) -> String { "\(userName) вступил в чат" }
        static func quitChatMessage(userName: String) -> String { "\(userName) покинул чат" }
        static let gradientBackgroundColor: [Color] = [
            Color(red: 168/255, green: 255/255, blue: 59/255),
            Color(red: 111/255, green: 135/255, blue: 255/255),
            Color(red: 215/255, green: 161/255, blue: 255/255),
            Color(red: 113/255, green: 190/255, blue: 255/255),
        ]
    }
}
