import Foundation
import SocketIO


final class WebSocketService {
    static let shared = WebSocketService()
    
    private var manager: SocketManager
    private var socket: SocketIOClient
    
    private init() {
        let url = URL(string: "http://192.168.0.101:3000")! // Замените на ваш сервер
        manager = SocketManager(socketURL: url, config: [.compress])
        socket = manager.defaultSocket
    }
    
    func connect() {
        // Устанавливаем слушатели перед подключением
        setupEventListeners()
        
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket connected")
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("Socket disconnected")
        }
        
        socket.on(clientEvent: .error) { data, ack in
            print("Socket error:", data)
        }
        
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    // MARK: - Установка слушателей
    func setupEventListeners() {
        let events = [
            "lobby-created",
            "player-joined",
            "game-started",
            "card-opened",
            "player-kicked",
            "game-ended",
            "round-updated",
            "error"
        ]
        
        for event in events {
            socket.on(event) { [weak self] data, ack in
                guard let self = self else { return }
                
                // Публикуем событие в NotificationCenter
                self.postNotification(for: event, with: data)
            }
        }
    }
    
    // MARK: - Отправка уведомлений
    private func postNotification(for event: String, with data: [Any]) {
        // Подготавливаем информацию для уведомления
        var userInfo: [String: Any] = [:]
        if let firstData = data.first, let dictionary = firstData as? [String: Any] {
            userInfo = dictionary
        }
        
        // Отправляем уведомление
        NotificationCenter.default.post(name: Notification.Name(event), object: nil, userInfo: userInfo)
    }
    
    // MARK: - Эмит событий
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
