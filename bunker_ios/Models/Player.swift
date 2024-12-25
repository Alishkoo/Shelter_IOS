

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

    var isProfessionOpened: Bool 
    var isBiologyOpened: Bool
    var isHealthOpened: Bool
    var isHobbyOpened: Bool
    var isLuggageOpened: Bool
    var isFactsOpened: Bool
    var isSpecialConditionOpened: Bool

    var isAlive: Bool
}
