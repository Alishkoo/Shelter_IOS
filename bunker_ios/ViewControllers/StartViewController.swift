
import UIKit

class StartViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter your name"
        label.font = UIFont(name: "Copperplate", size: 24)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            nameTextField.widthAnchor.constraint(equalToConstant: 250),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 30),
            submitButton.widthAnchor.constraint(equalToConstant: 150),
            submitButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // действие на кнопку
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    // функция для проверки имени то что есть ли оно в локалстрейдже
    private func checkForSavedName() {
        if let savedName = UserDefaults.standard.string(forKey: "playerName") {
            nameTextField.text = savedName
            nameTextField.isUserInteractionEnabled = false
            print("Name already exists:", savedName)
        }
    }
    // если поле пустое то не отправлять дальше
    @objc private func submitButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(message: "Please enter your name")
            return
        }
        
        // что бы клавы не было видно
        nameTextField.resignFirstResponder()
        
        if let _ = UserDefaults.standard.string(forKey: "playerId") {
                   navigateToLobby()
                   return
               }
               
        createPlayer(name: name)
    }
    
    private func createPlayer(name: String) {
        SpinnerManager.shared.showSpinner(on: view)
        // создает апишку игрока
        PlayerAPIManager.shared.createPlayer(withName: name) { [weak self] result in
            DispatchQueue.main.async {
                SpinnerManager.shared.hideSpinner()
                
                switch result { // сохранение
                case .success(let player):
                    self?.savePlayerToLocalStorage(name: player.name, id: player.id)
                    self?.navigateToLobby()
                    
                case .failure(let error):
                    self?.showAlert(message: "Failed to create player: \(error.localizedDescription)")
                }
            }
        }
    }
    // отправляет в локалсторейдж
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
    // проход дальше в лоббивьюконтроллер
    private func navigateToLobby() {
        let lobbyVC = LobbyViewController()
        navigationController?.pushViewController(lobbyVC, animated: true)
    }
    // для удаление
    private func clearPlayerData() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "playerName")
        defaults.removeObject(forKey: "playerId")
        print("Player data cleared from UserDefaults")
    }
}

