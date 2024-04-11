//
//  WebSocketController.swift
//
//
//  Created by Dmitriy Permyakov on 10.04.2024.
//

import Vapor

// MARK: - WebSocketController

final class WebSocketController: RouteCollection {

    // MARK: Private Values

    private var wsClients: Set<Client> = Set()

    // MARK: Router

    func boot(routes: RoutesBuilder) throws {

        // WebSocket
        routes.webSocket("socket", onUpgrade: handleSocketUpgrade)
    }
}

// MARK: - Web Sockets

private extension WebSocketController {

    func handleSocketUpgrade(req: Request, ws: WebSocket) {
        Logger.log(message: "Подключение")

        ws.onText { [weak self] ws, text in
            guard let self, let data = text.data(using: .utf8) else {
                Logger.log(kind: .error, message: "Неверный привод типа `text.data(using: .utf8)`")
                return
            }

            do {
                let msgKind = try JSONDecoder().decode(MessageAbstract.self, from: data)

                switch msgKind.kind {
                case .connection:
                    try self.connectionHandler(ws: ws, data: data)

                case .message:
                    try self.messageHandler(ws: ws, data: data)

                case .close:
                    break
                }

            } catch {
                Logger.log(kind: .error, message: error)
            }
        }

        ws.onClose.whenComplete { [weak self] _ in
            guard let self, let client = wsClients.first(where: { $0.ws === ws }) else { return }
            do {
                try closeHandler(ws: ws, client: client)
            } catch {
                Logger.log(kind: .error, message: error)
            }
        }
    }

    func connectionHandler(ws: WebSocket, data: Data) throws {
        let msg = try JSONDecoder().decode(Message.self, from: data)
        let newClient = Client(ws: ws, userName: msg.userName, userID: msg.userID)
        wsClients.insert(newClient)
        let msgConnection = Message(
            id: UUID(),
            kind: .connection,
            userName: msg.userName,
            userID: msg.userID,
            receiverID: msg.receiverID,
            dispatchDate: Date(),
            message: "",
            state: .received
        )
        let msgConnectionString = try msgConnection.encodeMessage()
        Logger.log(kind: .connection, message: "Пользователь с ником: [ \(msg.userName) ] добавлен в сессию")
        wsClients.forEach {
            $0.ws.send(msgConnectionString)
        }
    }

    func messageHandler(ws: WebSocket, data: Data) throws {
        var msg = try JSONDecoder().decode(Message.self, from: data)
        msg.state = .received
        let jsonString = try msg.encodeMessage()
        
        wsClients.forEach { client in
            if client.userID == msg.receiverID || client.userID == msg.userID {
                Logger.log(kind: .message, message: "Отправляю сообщение для \(client.userName):\n[\(msg)]")
                client.ws.send(jsonString)
            }
        }
    }

    func closeHandler(ws: WebSocket, client: Client) throws {
        guard let deletedClient = wsClients.remove(Client(ws: ws, userName: client.userName, userID: client.userID)) else {
            Logger.log(kind: .error, message: "Не удалось удалить пользователя: [ \(client.userName) ]")
            return
        }

        Logger.log(kind: .close, message: "Пользователь с ником: [ \(deletedClient.userName) ] удалён из очереди")
        let msgConnection = Message(
            id: UUID(),
            kind: .close,
            userName: client.userName,
            userID: client.userID,
            receiverID: client.userID,
            dispatchDate: Date(),
            message: "",
            state: .received
        )
        let msgConnectionString = try msgConnection.encodeMessage()
        client.ws.send(msgConnectionString)
    }
}
