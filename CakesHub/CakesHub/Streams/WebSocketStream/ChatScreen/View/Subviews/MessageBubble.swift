//
//  MessageBubble.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26.03.2024.
//

import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage
    var isYou: Bool { message.isYou }

    var body: some View {
        DefaultMessage
    }
}

// MARK: - Subviews

private extension MessageBubble {

    var DefaultMessage: some View {
        HStack(alignment: .bottom) {
            if !isYou {
                PersoneAvatar
            }

            VStack(alignment: isYou ? .trailing : .leading) {
                VStack(alignment: .leading, spacing: 2) {
                    if !isYou {
                        Text(message.userName)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.mint.gradient)
                    }

                    HStack(alignment: .bottom) {
                        Text(message.message)

                        HStack(spacing: 3) {
                            Text(message.time)
                                .foregroundStyle(.white.opacity(0.63))
                                .font(.system(size: 11, weight: .semibold))

                            if isYou {
                                message.state.image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 14, height: 14)
                                    .padding(.trailing, 5)
                                    .foregroundStyle(message.state.imageColor)
                            }
                        }
                    }
                    .padding(.bottom, 4)
                }
                .padding(.leading, 10)
                .padding([.top], 6)
                .padding(.trailing, isYou ? 2 : 8)
                .background(Constants.messageBackgroundColor, in: .rect(cornerRadius: 18))
                .frame(maxWidth: 320, alignment: isYou ? .trailing : .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: isYou ? .trailing : .leading)
    }

    var PersoneAvatar: some View {
        Circle()
            .fill(.mint.gradient)
            .frame(width: 32, height: 32)
            .overlay {
                Text("\(message.userName.first?.description.uppercased() ?? "😎")")
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
            }
    }
}

// MARK: - Message State

private extension Message.State {

    var image: Image {
        switch self {
        case .error: return Constants.errorImage
        case .received: return Constants.receivedImage
        case .progress: return Constants.progressImage
        }
    }

    var imageColor: Color {
        switch self {
        case .error: return Color(red: 1, green: 0, blue: 0)
        default: return .white.opacity(0.63)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        MessageBubble(
            message: .init(
                isYou: true,
                message: "Hi! 🤗 You can switch patterns and gradients in the settings.",
                userName: "mightyK1ngRichard",
                time: "10:10",
                state: .received
            )
        )

        MessageBubble(
            message: .init(
                isYou: false,
                message: "Воу рил неплохо",
                userName: "Пермяков Дмитрий",
                time: "10:10",
                state: .error
            )
        )
    }
}

// MARK: - Constants

private extension Message.State {

    enum Constants {
        static let receivedImage = Image("checkMark2")
        static let errorImage = Image(systemName: "exclamationmark.arrow.circlepath")
        static let progressImage = Image(systemName: "clock.arrow.circlepath")
    }
}

private extension MessageBubble {

    enum Constants {
        static let messageBackgroundColor = Color(red: 103/255, green: 77/255, blue: 122/255)
        static let textFieldBackgroundColor = Color(red: 6/255, green: 6/255, blue: 6/255)
        static let textFieldStrokeColor = Color(red: 58/255, green: 58/255, blue: 60/255)
        static let bottomBackgroundColor = Color(red: 28/255, green: 28/255, blue: 29/255)
    }
}
