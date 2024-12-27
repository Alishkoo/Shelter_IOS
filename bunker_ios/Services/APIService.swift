

import Foundation
import Alamofire

class PlayerAPIManager {
    static let shared = PlayerAPIManager()
    
    private let baseUrl = "172.20.10.2:3000"

    
    func createPlayer(withName name: String, completion: @escaping (Result<Player, Error>) -> Void) {
        let url = "\(baseUrl)/player/create"
        let parameters: [String: Any] = ["name": name]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: Player.self) { response in
                if let data = response.data {
                    // Логируем необработанный JSON для отладки
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Raw JSON Response: \n\(jsonString)")
                    } else {
                        print("Unable to format JSON response.")
                    }
                }
                
                // Обработка результата декодирования
                switch response.result {
                case .success(let player):
                    completion(.success(player))
                case .failure(let error):
                    print("Decoding error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
            
    }
}
