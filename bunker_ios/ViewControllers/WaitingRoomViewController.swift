
import UIKit

class WaitingRoomViewController: UIViewController {
    // Заголовок (например, для отображения текущего состояния лобби)
    private let lobbyInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Waiting for players..." // Текст по умолчанию
        label.font = UIFont(name: "Copperplate", size: 24.0)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Кнопка "Start the Game"
    private let startGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start the Game", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.systemYellow
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.titleLabel?.font = UIFont(name: "Copperplate", size: 16.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Lobby ID
    var lobbyId: String? {
        didSet {
            updateLobbyInfo()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        addNotificationObservers()
    }
    
    private func setupUI() {
        view.addSubview(lobbyInfoLabel)
        view.addSubview(startGameButton)
        
        NSLayoutConstraint.activate([
            // Лейбл с информацией о лобби
            lobbyInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lobbyInfoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            lobbyInfoLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            // Кнопка "Start the Game"
            startGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startGameButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            startGameButton.widthAnchor.constraint(equalToConstant: 200),
            startGameButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Добавляем действие на кнопку
        startGameButton.addTarget(self, action: #selector(startGameTapped), for: .touchUpInside)
    }
    
    private func updateLobbyInfo() {
        guard let lobbyId = lobbyId else { return }
        lobbyInfoLabel.text = """
        Waiting for players...
        Lobby ID: \(lobbyId)
        """
    }
    
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handlePlayerJoined(_:)), name: Notification.Name("player-joined"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleError(_:)), name: Notification.Name("error"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleGameStarted(_:)), name: Notification.Name("game-started"), object: nil)
    }
    
    @objc private func startGameTapped() {
        guard let lobbyId = lobbyId else {
            showAlert(message: "Lobby ID is missing.")
            return
        }
        
        // Отправляем событие "start-game" через WebSocketService
        WebSocketService.shared.startGame(lobbyId: lobbyId)
        SpinnerManager.shared.showSpinner(on: view)
    }
    
    @objc private func handlePlayerJoined(_ notification: Notification) {
        SpinnerManager.shared.hideSpinner()
        
        // Лог входящих данных для отладки
        print("Notification received: \(notification.userInfo ?? [:])")
        
        guard let userInfo = notification.userInfo else {
            showAlert(message: "Failed to retrieve lobby data: userInfo is nil.")
            return
        }
        
        do {
            // Преобразуем `userInfo` в Data для парсинга
            let jsonData = try JSONSerialization.data(withJSONObject: userInfo, options: [])
            let updatedLobby = try JSONDecoder().decode(Lobby.self, from: jsonData)
            
            // Успешный парсинг, обновляем интерфейс
            updateUI(with: updatedLobby)
        } catch {
            print("Failed to decode Lobby: \(error.localizedDescription)")
            print("Raw userInfo: \(userInfo)")
            showAlert(message: "Failed to parse lobby information. Please try again.")
        }
    }
    
    @objc private func handleGameStarted(_ notification: Notification) {
        SpinnerManager.shared.hideSpinner()
        
        // Лог входящих данных
        print("Notification received: \(notification.userInfo ?? [:])")
        
        guard let userInfo = notification.userInfo else {
            showAlert(message: "Failed to retrieve game data: userInfo is nil.")
            return
        }
        
        do {
            // Преобразуем `userInfo` в Data
            let jsonData = try JSONSerialization.data(withJSONObject: userInfo, options: [])
            let gameStartedData = try JSONDecoder().decode(GameStartedData.self, from: jsonData)
            
            // Успешный парсинг
            let gameData = gameStartedData
//            print(lobby)
            
            // Переход к следующему экрану
            let tabBarViewController = TabBarViewController()
            tabBarViewController.gameData = gameData
            navigationController?.pushViewController(tabBarViewController, animated: true)
        } catch {
            print("Failed to decode game data: \(error.localizedDescription)")
            print("Raw userInfo: \(userInfo)")
            showAlert(message: "Failed to parse game data.")
        }
    }
    
    private func updateUI(with lobby: Lobby) {
        let playerNames = lobby.players.map { $0.name }
        
        lobbyInfoLabel.text = """
        Waiting for players...
        Lobby ID: \(lobby.lobbyCode)
        
        Players:
        \(playerNames.joined(separator: "\n"))
        """
    }
    
    @objc private func handleError(_ notification: Notification) {
        showAlert(message: "An error occurred. Please try again.")
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
