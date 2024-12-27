

import UIKit

class LobbyViewController: UIViewController {
    
    // Логотип (ImageView)
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "shelterLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // "Create a game"
    private let createGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create a game", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Copperplate", size: 24.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // "Join game"
    private let joinGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Join game", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Copperplate", size: 24.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(createGameButton)
        view.addSubview(joinGameButton)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            
            createGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createGameButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),

            joinGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            joinGameButton.topAnchor.constraint(equalTo: createGameButton.bottomAnchor, constant: 20)
        ])
        
        createGameButton.addTarget(self, action: #selector(createGameTapped), for: .touchUpInside)
        joinGameButton.addTarget(self, action: #selector(joinGameTapped), for: .touchUpInside)
    }
    
    // Переход на экран "Create a game"
    @objc private func createGameTapped() {
        let createGameVC = CreateGameViewController()
        navigationController?.pushViewController(createGameVC, animated: true)
    }
    
    // Переход на экран "Join game"
    @objc private func joinGameTapped() {
        let joinGameVC = JoinGameViewController()
        navigationController?.pushViewController(joinGameVC, animated: true)
    }
}
