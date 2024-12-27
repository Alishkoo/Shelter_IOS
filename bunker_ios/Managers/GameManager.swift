//import Foundation
//
//final class GameManager {
//    static let shared = GameManager()
//    
//    private init() {}
//    
//    // Текущее состояние лобби
//    var currentLobby: Lobby?
//    var isOwner: Bool = false // Флаг, является ли текущий пользователь владельцем лобби
//    
//    // MARK: - Методы для управления игрой
//    
//    func createLobby(playerId: String, lobbyId: String) {
//        WebSocketService.shared.createLobby(playerId: playerId, lobbyId: lobbyId)
//        isOwner = true
//    }
//    
//    func joinLobby(playerId: String, lobbyId: String) {
//        WebSocketService.shared.joinLobby(playerId: playerId, lobbyId: lobbyId)
//        isOwner = false
//    }
//    
//    func startGame() {
//        guard let lobbyId = currentLobby?.lobbyId else {
//            print("Вы не владелец или лобби не найдено")
//            return
//        }
//        WebSocketService.shared.startGame(lobbyId: lobbyId)
//    }
//    
//    func openCard(playerId: String, cardType: String) {
//        guard let lobbyId = currentLobby?.lobbyId else {
//            print("Лобби не найдено")
//            return
//        }
//        WebSocketService.shared.openCard(lobbyId: lobbyId, playerId: playerId, cardType: cardType)
//    }
//    
//    func kickPlayer(playerId: String) {
//        guard let lobbyId = currentLobby?.lobbyId else {
//            print("Вы не владелец или лобби не найдено")
//            return
//        }
//        WebSocketService.shared.kickPlayer(lobbyId: lobbyId, playerId: playerId)
//    }
//    
//    func nextRound() {
//        guard let lobbyId = currentLobby?.lobbyId else {
//            print("Вы не владелец или лобби не найдено")
//            return
//        }
//        WebSocketService.shared.nextRound(lobbyId: lobbyId)
//    }
//    
//    func endGame() {
//        guard let lobbyId = currentLobby?.lobbyId else {
//            print("Вы не владелец или лобби не найдено")
//            return
//        }
//        WebSocketService.shared.endGame(lobbyId: lobbyId)
//    }
//    
//    // MARK: - Установка слушателей WebSocket
//    func setupWebSocketListeners() {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleLobbyCreated(_:)), name: Notification.Name("lobby-created"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handlePlayerJoined(_:)), name: Notification.Name("player-joined"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleGameStarted(_:)), name: Notification.Name("game-started"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleCardOpened(_:)), name: Notification.Name("card-opened"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleRoundUpdated(_:)), name: Notification.Name("round-updated"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handlePlayerKicked(_:)), name: Notification.Name("player-kicked"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleGameEnded(_:)), name: Notification.Name("game-ended"), object: nil)
//    }
//    
//    // MARK: - Реализовать в ViewController
//    
//    @objc private func handleLobbyCreated(_ notification: Notification) {
//        guard let userInfo = notification.userInfo,
//              let lobbyId = userInfo["lobbyId"] as? String else { return }
//        
//        print("Лобби создано с ID:", lobbyId)
//        // Здесь можно обновить UI или состояние, если нужно
//    }
//    
//    @objc private func handlePlayerJoined(_ notification: Notification) {
//        guard let userInfo = notification.userInfo else { return }
////        parseLobbyData(userInfo)
//        print("Игрок присоединился. Обновлённое лобби:", currentLobby?.players.map { $0.name } ?? [])
//    }
//    
//    @objc private func handleGameStarted(_ notification: Notification) {
//        guard let userInfo = notification.userInfo,
//              let lobbyData = userInfo["lobby"] as? [String: Any],
//              let playersData = userInfo["players"] as? [[String: Any]] else { return }
//        
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: lobbyData, options: [])
//            let lobby = try JSONDecoder().decode(Lobby.self, from: jsonData)
//            currentLobby = lobby
//            
//            let players = playersData.compactMap { playerDict -> Player? in
//                guard let jsonData = try? JSONSerialization.data(withJSONObject: playerDict, options: []) else { return nil }
//                return try? JSONDecoder().decode(Player.self, from: jsonData)
//            }
//            print("Игра началась с игроками:", players.map { $0.name })
//        } catch {
//            print("Ошибка при обработке данных 'game-started':", error)
//        }
//    }
//    
//    @objc private func handleCardOpened(_ notification: Notification) {
//        guard let userInfo = notification.userInfo else { return }
////        parseLobbyData(userInfo)
//        print("Карта открыта. Обновлённое лобби:", currentLobby?.players.map { $0.name } ?? [])
//    }
//    
//    @objc private func handleRoundUpdated(_ notification: Notification) {
//        guard let userInfo = notification.userInfo else { return }
////        parseLobbyData(userInfo)
//        print("Раунд обновлён. Текущий раунд:", currentLobby?.currentRound ?? 0)
//    }
//    
//    @objc private func handlePlayerKicked(_ notification: Notification) {
//        guard let userInfo = notification.userInfo else { return }
////        parseLobbyData(userInfo)
//        print("Игрок исключён. Обновлённое лобби:", currentLobby?.players.map { $0.name } ?? [])
//    }
//    
//    @objc private func handleGameEnded(_ notification: Notification) {
//        guard let userInfo = notification.userInfo else { return }
////        parseLobbyData(userInfo)
//        print("Игра завершилась")
//    }
//    
//    // MARK: - Общий парсинг лобби
//    private func parseLobbyData(_ userInfo: [String: Any]) {
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: userInfo, options: [])
//            let lobby = try JSONDecoder().decode(Lobby.self, from: jsonData)
//            currentLobby = lobby
//            NotificationCenter.default.post(name: Notification.Name("lobby-updated"), object: nil, userInfo: userInfo)
//        } catch {
//            print("Ошибка при обработке данных Lobby:", error)
//        }
//    }
//}
