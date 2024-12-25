

import Foundation

class LocalStorageManager {
    static let shared = LocalStorageManager()
    
    private let playerIdKey = "playerId"
    private let playerNameKey = "playerName"

    
    func hasPlayerData() -> Bool {
        return UserDefaults.standard.string(forKey: playerIdKey) != nil &&
               UserDefaults.standard.string(forKey: playerNameKey) != nil
    }
    
   
    func savePlayerData(playerId: String, playerName: String) {
        UserDefaults.standard.set(playerId, forKey: playerIdKey)
        UserDefaults.standard.set(playerName, forKey: playerNameKey)
    }
    
    
    func getPlayerData() -> (playerId: String?, playerName: String?) {
        let playerId = UserDefaults.standard.string(forKey: playerIdKey)
        let playerName = UserDefaults.standard.string(forKey: playerNameKey)
        return (playerId, playerName)
    }
}
