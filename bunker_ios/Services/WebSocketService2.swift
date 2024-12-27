
import Foundation
import SocketIO

final class WebSocketService2 {
    static let shared = WebSocketService2()
    
    private var manager: SocketManager
    private var socket: SocketIOClient
    
    
    private init() {
        let url = URL(string: "http://YOUR_SERVER_URL")!
        manager = SocketManager(socketURL: url, config: [.log(true), .compress])
        socket = manager.defaultSocket
    }
    
    // MARK: - Подключение
    func connect() {
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket connected")
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("Socket disconnected")
        }
        
        // Подключение с обработкой ошибок
        socket.on(clientEvent: .error) { data, ack in
            print("Socket error:", data)
        }
        
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    // MARK: - Обработка событий
    func setupEventListeners() {
        socket.on("lobby-created") { data, ack in
            if let response = data.first as? [String: Any] {
                print("Lobby created:", response)
            }
        }
        
        socket.on("player-joined") { data, ack in
            if let response = data.first as? [String: Any] {
                print("Player joined:", response)
            }
        }
        
        socket.on("game-started") { data, ack in
            if let response = data.first as? [String: Any] {
                print("Game started:", response)
            }
        }
        
        socket.on("card-opened") { data, ack in
            if let response = data.first as? [String: Any] {
                print("Card opened:", response)
            }
        }
        
        socket.on("error") { data, ack in
            if let errorMessage = data.first as? String {
                print("Error received:", errorMessage)
            }
        }
        
        socket.on("player-kicked") { data, ack in
            if let response = data.first as? [String: Any] {
                print("Player kicked:", response)
            }
        }
        
        socket.on("game-ended") { data, ack in
            if let response = data.first as? [String: Any] {
                print("Game ended:", response)
            }
        }
    }
    
    // MARK: - Отправка событий
    func createLobby(playerId: String, lobbyId: String) {
        socket.emit("create-lobby", ["playerId": playerId, "lobbyId": lobbyId])
    }
    
    func joinLobby(playerId: String, lobbyId: String) {
        socket.emit("join-lobby", ["playerId": playerId, "lobbyId": lobbyId])
    }
    
    func startGame(lobbyId: String) {
        socket.emit("start-game", ["lobbyId": lobbyId])
    }
    
    func openCard(lobbyId: String, playerId: String, cardType: String) {
        socket.emit("open-card", ["lobbyId": lobbyId, "playerId": playerId, "cardType": cardType])
    }
    
    func kickPlayer(lobbyId: String, playerId: String) {
        socket.emit("kick-player", ["lobbyId": lobbyId, "playerId": playerId])
    }
    
    func nextRound(lobbyId: String) {
        socket.emit("next-round", ["lobbyId": lobbyId])
    }
    
    func endGame(lobbyId: String) {
        socket.emit("end-game", ["lobbyId": lobbyId])
    }
}

