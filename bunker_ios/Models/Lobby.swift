
import Foundation

struct GameStartedData: Codable {
    var lobby: Lobby
    var players: [PlayerWithCard]
}

struct Lobby: Codable {
    let id: String
    let lobbyCode: String
    let players: [Player]
    let gameState: GameState?
    let currentRound: Int?
    let threatCards: [String]?
    let bunkerCards: [String]?
    let createdAt: String
    let updatedAt: String
    let disasterCard: String?
    let version: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case lobbyCode
        case players
        case gameState
        case currentRound
        case threatCards
        case bunkerCards
        case createdAt
        case updatedAt
        case disasterCard
        case version = "__v"
    }
}


enum GameState: String, Codable {
    case waiting = "waiting"
    case inProgress = "inProgress"
    case finished = "finished"
}
