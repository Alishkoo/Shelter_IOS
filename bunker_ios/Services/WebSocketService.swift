

import Foundation
import SocketIO

class WebSocketService {
    static let shared = WebSocketService()

    private var manager: SocketManager!
    private var socket: SocketIOClient!

    private init() {
        let socketURL = URL(string: "https://yourserver.com")!

        manager = SocketManager(socketURL: socketURL, config: [.log(true), .compress])
        socket = manager.defaultSocket

        // Обработчики событий WebSocket
        socket.on(clientEvent: .connect) {data, ack in
            print("Connected to WebSocket")
        }

        socket.on(clientEvent: .disconnect) {data, ack in
            print("Disconnected from WebSocket")
        }

//        socket.on("lobby-created") { data, ack in
//            // Это событие будет срабатывать, когда сервер отправит подтверждение создания лобби
//            if let lobbyData = data.first as? [String: Any] {
//                NotificationCenter.default.post(name: .lobbyCreated, object: lobbyData)
//            }
//        }

        socket.on("error") { data, ack in
            print("Error: \(data)")
        }
    }

    func connect() {
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
    }

    func emit(event: String, data: [String: Any]) {
        socket.emit(event, data)
    }

    //С замыканием было сделано!
    func createLobby(playerId: String, lobbyId: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let data = ["playerId": playerId, "lobbyId": lobbyId]
        emit(event: "create-lobby", data: data)
        
        // Обработчик для ответа от сервера
        socket.on("lobby-created") { data, ack in
            if let lobbyData = data.first as? [String: Any] {
                completion(.success(lobbyData))
            } else {
                let error = NSError(domain: "WebSocketError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create lobby"])
                completion(.failure(error))
            }
        }
    }
}
