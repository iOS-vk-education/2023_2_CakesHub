//
//  WebSockerManager.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 11.04.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import Foundation

protocol WebSockerManagerProtocol: AnyObject {
    func connection(completion: @escaping CHMGenericBlock<Error?>)
    func send<T: Codable>(message: T, completion: @escaping CHMVoidBlock)
    func receive<T: Decodable>(completion: @escaping CHMGenericBlock<T>)
    func close()
}

// MARK: - WebSockerManager

final class WebSockerManager {
    private let urlMessage: String = "ws://localhost:8080/socket"
    static let shared: WebSockerManagerProtocol = WebSockerManager()
    private var webSocketTask: URLSessionWebSocketTask?
    private init() {}
}

// MARK: - Actions

extension WebSockerManager: WebSockerManagerProtocol {

    func connection(completion: @escaping CHMGenericBlock<Error?>) {
        guard let url = URL(string: urlMessage) else { return }
        webSocketTask = URLSession(configuration: .default).webSocketTask(with: url)
        webSocketTask?.resume()
        webSocketTask?.sendPing(pongReceiveHandler: completion)
    }

    func close() {
        webSocketTask?.cancel()
        webSocketTask = nil
    }

    func send<T: Encodable>(message: T, completion: @escaping CHMVoidBlock) {
        do {
            let jsonData = try JSONEncoder().encode(message)
            guard let jsonString = String(data: jsonData, encoding: .utf8) else { return }
            let text = URLSessionWebSocketTask.Message.string(jsonString)
            webSocketTask?.send(text) { error in
                if let error {
                    Logger.log(kind: .error, message: error)
                    return
                }
                completion()
            }
        } catch {
            Logger.log(kind: .error, message: error.localizedDescription)
        }
    }

    func receive<T: Decodable>(completion: @escaping CHMGenericBlock<T>) {
        webSocketTask?.receive { [weak self] result in
            guard let self, webSocketTask != nil else { return }
            switch result {
            case let .success(enumMessage):
                defer { receive(completion: completion) }

                switch enumMessage {
                case .data: break
                case let .string(stringMessage):
                    Logger.log(message: "Получено сообщение: [ " + stringMessage + " ]")
                    guard let data = stringMessage.data(using: .utf8) else { return }
                    do {
                        let message = try JSONDecoder().decode(T.self, from: data)
                        completion(message)
                    } catch {
                        Logger.log(
                            kind: .error,
                            message: "Не получилось распарсить сообщение: [ \(stringMessage) ] к типу \(T.Type.self).self.\n [ \(error.localizedDescription) ]"
                        )
                    }
                @unknown default: break
                }

            case let .failure(error):
                Logger.log(kind: .error, message: error.localizedDescription)
            }
        }
    }
}
