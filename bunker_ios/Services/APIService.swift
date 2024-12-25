

import Foundation
import Alamofire

class PlayerAPIManager {
    static let shared = PlayerAPIManager()
    
    private let baseUrl = "https://yourserver.com/api"

    
    func createPlayer(withName name: String, completion: @escaping (Result<Player, Error>) -> Void) {
        let url = "\(baseUrl)/players"
        let parameters: [String: Any] = ["name": name]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: Player.self) { response in
                switch response.result {
                case .success(let player):
                    completion(.success(player))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
