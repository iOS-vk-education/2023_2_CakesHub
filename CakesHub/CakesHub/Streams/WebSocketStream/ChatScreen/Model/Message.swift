//
//  Message.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 26.03.2024.
//

import UIKit

struct Message: Codable, Identifiable {
    var id: UUID
    let kind: MessageKind
    let user: UserChatCellInfo
    let dispatchDate: Date
    let message: String
    var state: State

    enum MessageKind: String, Codable {
        case connection
        case message
        case close
    }

    enum State: String, Codable {
        case progress
        case received
        case error
    }

    struct UserChatCellInfo: Hashable, Codable {
        let userName: String
        let userImage: Data?

        enum CodingKeys: String, CodingKey {
            case userName
            case userImage
        }

        init(userName: String, userImage: Data?) {
            self.userName = userName
            self.userImage = userImage
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            userName = try container.decode(String.self, forKey: .userName)
            userImage = try container.decodeIfPresent(Data.self, forKey: .userImage)
        }
    }
}

// MARK: - Mapper

extension Message {

    func mapper(name: String) -> ChatMessage {
        .init(
            id: id,
            isYou: user.userName == name,
            message: message,
            user: .init(name: user.userName, image: user.userImage.mapper),
            time: dispatchDate.formattedString(format: "HH:mm"),
            state: state
        )
    }
}

// MARK: - Helper

private extension Data? {

    var mapper: ImageKind {
        guard let data = self else { return .clear }
        return .uiImage(UIImage(data: data))
    }
}

private extension Date {

    func formattedString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
