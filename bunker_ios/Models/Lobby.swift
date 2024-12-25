
import Foundation

struct Lobby: Codable {
    let id: String
    let lobbyId: String

    let players: [Player]
    let gameState: GameState
    let currentRound: Int

    let disasterCard: String?
    let threatCards: [String]
    let bunkerCards: [String]
}

enum GameState: String, Codable {
    case waiting = "waiting"
    case inProgress = "inProgress"
    case finished = "finished" 
}
