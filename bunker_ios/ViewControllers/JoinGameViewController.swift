

import UIKit

class JoinGameViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your game code"
        label.font = UIFont(name: "Copperplate", size: 24.0)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let gameCodeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Game code"
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 8
        textField.font = UIFont(name: "Copperplate", size: 16.0)
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.systemYellow
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.titleLabel?.font = UIFont(name: "Copperplate", size: 20.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        addNotificationObservers()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(gameCodeTextField)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            gameCodeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameCodeTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            gameCodeTextField.widthAnchor.constraint(equalToConstant: 250),
            gameCodeTextField.heightAnchor.constraint(equalToConstant: 40),
            
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.topAnchor.constraint(equalTo: gameCodeTextField.bottomAnchor, constant: 30),
            submitButton.widthAnchor.constraint(equalToConstant: 150),
            submitButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    // нажатие кнопки захода в лобби
    @objc private func submitButtonTapped() {
        guard let lobbyId = gameCodeTextField.text, !lobbyId.isEmpty else {
                showAlert(message: "Please enter a valid game code.")
                return
        }
                
        guard let playerId = UserDefaults.standard.string(forKey: "playerId") else {
                showAlert(message: "Player ID is missing.")
                return
        }
                
        // Отправление "join-lobby" на сервер
        WebSocketService.shared.joinLobby(playerId: playerId, lobbyId: lobbyId)
        SpinnerManager.shared.showSpinner(on: view)
    }
    
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handlePlayerJoined(_:)), name: Notification.Name("player-joined"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleError(_:)), name: Notification.Name("error"), object: nil)
    }
    
    @objc private func handlePlayerJoined(_ notification: Notification) {
        SpinnerManager.shared.hideSpinner()
                
    
        
        // Проверяем, что уведомление содержит данные
        guard let userInfo = notification.userInfo else {
            print("Notification userInfo is nil.")
            showAlert(message: "Failed to retrieve lobby information.")
            return
        }
        
        do {
            // Преобразуем `userInfo` в Data для парсинга
            let jsonData = try JSONSerialization.data(withJSONObject: userInfo, options: [])
            let decodedLobby = try JSONDecoder().decode(Lobby.self, from: jsonData)
            
            
            // Переход в комнату ожидания
            let waitingRoomVC = WaitingRoomViewController()
            waitingRoomVC.lobbyId = decodedLobby.lobbyCode
            
            // Лог игроков для проверки
            let playerNames = decodedLobby.players.map { $0.name }
            
            navigationController?.pushViewController(waitingRoomVC, animated: true)
        } catch {
            print("Failed to parse lobby data: \(error.localizedDescription)")
            showAlert(message: "An error occurred while parsing lobby data.")
        }
    }
    
    @objc private func handleError(_ notification: Notification) {
        SpinnerManager.shared.hideSpinner()
        showAlert(message: "Failed to join the lobby. Please check the code and try again.")
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
