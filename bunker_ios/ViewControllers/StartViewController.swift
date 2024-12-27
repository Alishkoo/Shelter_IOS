
import UIKit

class StartViewController: UIViewController {
    
    // Заголовок
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter your name"
        label.font = UIFont(name: "Copperplate", size: 24)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Поле для ввода имени
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Your name"
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 8
        textField.font = UIFont(name: "Copperplate", size: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // Кнопка Submit
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.systemYellow
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.titleLabel?.font = UIFont(name: "Copperplate", size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        checkForSavedName()
    }
    
    private func setupUI() {
        // Добавляем элементы на экран
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(submitButton)
        
        // Устанавливаем Constraints
        NSLayoutConstraint.activate([
            // Заголовок
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150), // Было 100, увеличили до 150
            
            // Поле ввода имени
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40), // Было 20, увеличили до 40
            nameTextField.widthAnchor.constraint(equalToConstant: 250),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Кнопка Submit
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 30), // Было 20, увеличили до 30
            submitButton.widthAnchor.constraint(equalToConstant: 150),
            submitButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Добавляем действие на кнопку
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    private func checkForSavedName() {
        if let savedName = UserDefaults.standard.string(forKey: "playerName") {
            nameTextField.text = savedName
            nameTextField.isUserInteractionEnabled = false
            print("Name already exists:", savedName)
        }
    }
    
    @objc private func submitButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(message: "Please enter your name")
            return
        }
        
        // Сброс фокуса с текстового поля
        nameTextField.resignFirstResponder()
        
        if let _ = UserDefaults.standard.string(forKey: "playerId") {
                   navigateToLobby()
                   return
               }
               
        createPlayer(name: name)
    }
    
    private func createPlayer(name: String) {
        SpinnerManager.shared.showSpinner(on: view)
        
        PlayerAPIManager.shared.createPlayer(withName: name) { [weak self] result in
            DispatchQueue.main.async {
                SpinnerManager.shared.hideSpinner()
                
                switch result {
                case .success(let player):
                    // Сохраняем данные игрока
                    self?.savePlayerToLocalStorage(name: player.name, id: player.id)
                    self?.navigateToLobby()
                    
                case .failure(let error):
                    // Показываем ошибку
                    self?.showAlert(message: "Failed to create player: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func savePlayerToLocalStorage(name: String, id: String) {
        guard !name.isEmpty, !id.isEmpty else {
                print("Invalid player data: name or id is empty")
                return
            }
        
        UserDefaults.standard.set(name, forKey: "playerName")
        UserDefaults.standard.set(id, forKey: "playerId")
        print("Player saved:", name, id)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func navigateToLobby() {
        let lobbyVC = LobbyViewController()
        navigationController?.pushViewController(lobbyVC, animated: true)
    }
    
    // for tests
    private func clearPlayerData() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "playerName")
        defaults.removeObject(forKey: "playerId")
        print("Player data cleared from UserDefaults")
    }
}

