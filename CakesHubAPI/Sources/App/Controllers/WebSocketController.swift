//
//  WebSocketController.swift
//
//
//  Created by Dmitriy Permyakov on 10.04.2024.
//

import Vapor

// MARK: - WebSocketController

final class WebSocketController: RouteCollection, @unchecked Sendable {

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

    @Sendable
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

                case .notification:
                    try self.notificationHandler(ws: ws, data: data)

                case .close:
                    break
                }

            } catch {
                Logger.log(kind: .error, message: error)
            }
        }

        ws.onClose.whenComplete { [weak self] _ in
            guard let self, let client = wsClients.first(where: { $0.ws === ws }) else {
                return
            }
            do {
                try closeHandler(ws: ws, client: client)
            } catch {
                Logger.log(kind: .error, message: error)
            }
        }
    }

    func connectionHandler(ws: WebSocket, data: Data) throws {
        let msg = try JSONDecoder().decode(Message.self, from: data)
        let newClient = Client(ws: ws, userID: msg.userID)
        wsClients.insert(newClient)
        let msgConnection = Message(
            id: UUID().uuidString,
            kind: .connection,
            userName: msg.userName,
            userID: msg.userID,
            receiverID: msg.receiverID,
            dispatchDate: Date(),
            message: "",
            state: .received
        )
        let msgConnectionString = try msgConnection.encodeMessage()
        Logger.log(kind: .connection, message: "Пользователь с id: [ \(msg.userID) ] добавлен в сессию")
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
                Logger.log(kind: .message, message: "Отправляю сообщение для \(client.userID):\n[\(msg)]")
                client.ws.send(jsonString)
            }
        }
    }

    func closeHandler(ws: WebSocket, client: Client) throws {
        guard let deletedClient = wsClients.remove(Client(ws: ws, userID: client.userID)) else {
            Logger.log(kind: .error, message: "Не удалось удалить пользователя: [ \(client.userID) ]")
            return
        }

        Logger.log(kind: .close, message: "Пользователь с ником: [ \(deletedClient.userID) ] удалён из очереди")
    }
}

// MARK: - Notifications

private extension WebSocketController {

    func notificationHandler(ws: WebSocket, data: Data) throws {
        let notification = try JSONDecoder().decode(Notification.self, from: data)
        Logger.log(message: "Полученно уведомление с title:\n\(notification.title)")

        let notificationData = try JSONEncoder().encode(notification)
        guard let notificationString = String(data: notificationData, encoding: .utf8) else {
            Logger.log(kind: .error, message: "Ошибка конвертирования в строку")
            throw Abort(.badRequest)
        }

        let receiverID = notification.receiverID
        for client in wsClients {
            if client.userID == receiverID {
                client.ws.send(notificationString)
                Logger.log(message: "Отправил текст получателю с id: \(receiverID)")
                return
            }
        }
    }
}
