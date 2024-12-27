import UIKit

class CreateGameViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your game code"
        label.font = UIFont(name: "Copperplate", size: 24.0)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let gameCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "000 000"
        label.font = UIFont(name: "Copperplate", size: 32.0)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create the game", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.systemYellow
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.titleLabel?.font = UIFont(name: "Copperplate", size: 20.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var lobbyId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        generateLobbyId()
        addNotificationObservers()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(gameCodeLabel)
        view.addSubview(createGameButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            gameCodeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameCodeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            
            createGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createGameButton.topAnchor.constraint(equalTo: gameCodeLabel.bottomAnchor, constant: 40),
            createGameButton.widthAnchor.constraint(equalToConstant: 200),
            createGameButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        createGameButton.addTarget(self, action: #selector(createGameTapped), for: .touchUpInside)
    }
    // создание лоббиАЙди
    private func generateLobbyId() {
        let randomId = (100_000...999_999).randomElement() ?? 555_555
        lobbyId = "\(randomId)"
        gameCodeLabel.text = formatLobbyId(lobbyId)
    }
    // раунды
    private func formatLobbyId(_ id: String) -> String {
        let splitIndex = id.index(id.startIndex, offsetBy: 3)
        let firstPart = id[..<splitIndex]
        let secondPart = id[splitIndex...]
        return "\(firstPart) \(secondPart)"
    }
    
    @objc private func createGameTapped() {
        guard let playerId = UserDefaults.standard.string(forKey: "playerId") else {
                    showAlert(message: "Player ID is missing.")
                    return
        }
                
        // создает игровкую комнату
        WebSocketService.shared.createLobby(playerId: playerId, lobbyId: lobbyId)
        SpinnerManager.shared.showSpinner(on: view)
    }
    // добавление наблюдателей за уведомлением
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleLobbyCreated(_:)), name: Notification.Name("lobby-created"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleError(_:)), name: Notification.Name("error"), object: nil)
        }
    // если приходит увед что лобби открыто начинает загружать
    @objc private func handleLobbyCreated(_ notification: Notification) {
        SpinnerManager.shared.hideSpinner()
            
        // Переход в комнату ожидания
        let waitingRoomVC = WaitingRoomViewController()
        waitingRoomVC.lobbyId = lobbyId
        navigationController?.pushViewController(waitingRoomVC, animated: true)
    }
        // при неудаче
    @objc private func handleError(_ notification: Notification) {
        SpinnerManager.shared.hideSpinner()
        showAlert(message: "Failed to create the lobby. Please try again.")
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
