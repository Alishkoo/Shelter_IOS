

import Foundation


struct Player: Codable {
    let id: String
    let name: String
    let profession: String?
    let biology: String?
    let health: String?
    let hobby: String?
    let baggage: String?
    let facts: String?
    let specialCondition: String?
    let isProfessionOpened: Bool
    let isBiologyOpened: Bool
    let isHealthOpened: Bool
    let isHobbyOpened: Bool
    let isBaggageOpened: Bool
    let isFactsOpened: Bool
    let isSpecialConditionOpened: Bool
    let isAlive: Bool
    let createdAt: String
    let updatedAt: String
    let version: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case profession
        case biology
        case health
        case hobby
        case baggage
        case facts
        case specialCondition
        case isProfessionOpened
        case isBiologyOpened
        case isHealthOpened
        case isHobbyOpened
        case isBaggageOpened
        case isFactsOpened
        case isSpecialConditionOpened
        case isAlive
        case createdAt
        case updatedAt
        case version = "__v"
    }
}

struct PlayerWithCard: Codable{
    let id: String
    let name: String
    let profession: Card?
    let biology: Card?
    let health: Card?
    let hobby: Card?
    let baggage: Card?
    let facts: Card?
    let specialCondition: Card?
    var isProfessionOpened: Bool
    var isBiologyOpened: Bool
    var isHealthOpened: Bool
    var isHobbyOpened: Bool
    var isBaggageOpened: Bool
    var isFactsOpened: Bool
    var isSpecialConditionOpened: Bool
    var isAlive: Bool
    let createdAt: String
    let updatedAt: String
    let version: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case profession
        case biology
        case health
        case hobby
        case baggage
        case facts
        case specialCondition
        case isProfessionOpened
        case isBiologyOpened
        case isHealthOpened
        case isHobbyOpened
        case isBaggageOpened
        case isFactsOpened
        case isSpecialConditionOpened
        case isAlive
        case createdAt
        case updatedAt
        case version = "__v"
    }
}

struct Card: Codable {
    let id: String
    let name: String
    let imageUrl: String
    let createdAt: String
    let updatedAt: String
    let version: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case imageUrl
        case createdAt
        case updatedAt
        case version = "__v"
    }
}
