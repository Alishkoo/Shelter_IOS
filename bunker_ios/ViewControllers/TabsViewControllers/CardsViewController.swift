

import UIKit

class CardsViewController: UIViewController, UIScrollViewDelegate {
    var gameData: GameStartedData? {
        didSet {
            guard let gameData = gameData else {
                print("gameData is nil")
                return
            }

            print(gameData)
            findCurrentPlayer()
        }
    }

    private var currentPlayer: PlayerWithCard?
    private let cardTypes = ["profession", "biology", "health", "hobby", "baggage", "facts", "specialCondition"]
    private var currentCardIndex: Int = 0 // Индекс текущей карты
    
    // Горизонтальный ScrollView
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = .zero
        scrollView.contentOffset = .zero
        scrollView.decelerationRate = .fast
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let revealCardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open the card", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Copperplate", size: 24.0)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let endGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("End game", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Copperplate", size: 24.0)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }

    private func setupUI() {
        view.addSubview(scrollView)
        view.addSubview(revealCardButton)
        view.addSubview(endGameButton)
        scrollView.addSubview(stackView)

        scrollView.delegate = self

        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6), // Высота ScrollView
            
            // StackView внутри ScrollView
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            // Кнопка "Раскрыть карту"
            revealCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            revealCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            revealCardButton.bottomAnchor.constraint(equalTo: endGameButton.topAnchor, constant: -10),
            revealCardButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Кнопка "Закончить игру"
            endGameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            endGameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            endGameButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            endGameButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupActions() {
        revealCardButton.addTarget(self, action: #selector(revealCardTapped), for: .touchUpInside)
        endGameButton.addTarget(self, action: #selector(endGameTapped), for: .touchUpInside)
    }

    private func findCurrentPlayer() {
        guard let gameData = gameData else { return }
        let savedPlayerId = UserDefaults.standard.string(forKey: "playerId")
        currentPlayer = gameData.players.first { $0.id == savedPlayerId }
        if let currentPlayer = currentPlayer {
            print("Current player found: \(currentPlayer.name)")
            loadCards(for: currentPlayer)
            updateRevealCardButtonState()
        } else {
            print("No matching player found in the game data.")
        }
    }

    private func loadCards(for player: PlayerWithCard) {
        let cards: [Card?] = [
            player.profession,
            player.biology,
            player.health,
            player.hobby,
            player.baggage,
            player.facts,
            player.specialCondition
        ]

        // Добавляем изображения карт в StackView
        for card in cards {
            let cardImageView = UIImageView()
            cardImageView.contentMode = .scaleAspectFit
            cardImageView.clipsToBounds = true
            cardImageView.backgroundColor = .white
            cardImageView.layer.cornerRadius = 8

            if let card = card, let url = URL(string: card.imageUrl) {
                cardImageView.kf.setImage(with: url)
            } else {
                cardImageView.image = UIImage(named: "Bunker backcard") // Если карты нет, используем заглушку
            }


            stackView.addArrangedSubview(cardImageView)

            NSLayoutConstraint.activate([
                cardImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                cardImageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
        }
    }

    @objc private func revealCardTapped() {
        guard let lobbyId = gameData?.lobby.lobbyCode else { return }
        guard let playerId = currentPlayer?.id else { return }
        
        // Определяем текущий тип карты
        let cardType = cardTypes[currentCardIndex]
        
        // Обновляем свойство isCardOpened для текущей карты
        switch cardType {
        case "profession": currentPlayer?.isProfessionOpened = true
        case "biology": currentPlayer?.isBiologyOpened = true
        case "health": currentPlayer?.isHealthOpened = true
        case "hobby": currentPlayer?.isHobbyOpened = true
        case "baggage": currentPlayer?.isBaggageOpened = true
        case "facts": currentPlayer?.isFactsOpened = true
        case "specialCondition": currentPlayer?.isSpecialConditionOpened = true
        default: break
        }
        
        // Обновляем данные в gameData
        if let index = gameData?.players.firstIndex(where: { $0.id == playerId }) {
            gameData?.players[index] = currentPlayer!
        }
        
        // Логика отправки запроса через WebSocket
        WebSocketService.shared.openCard(lobbyId: lobbyId, playerId: playerId, cardType: cardType)
        print("Card revealed: \(cardType)")
        
        // Обновляем состояние кнопки
        updateRevealCardButtonState()
    }

    @objc private func endGameTapped() {
        guard let lobbyId = gameData?.lobby.lobbyCode else { return }
//        WebSocketService.shared.endGame(lobbyId: lobbyId)
        print("Game ended")
    }

    // Отслеживаем текущую карту
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        guard pageWidth > 0 else { return }
        let offset = scrollView.contentOffset.x
        currentCardIndex = Int((offset + pageWidth / 2) / pageWidth)
        updateRevealCardButtonState()
    }

    private func updateRevealCardButtonState() {
        guard let currentPlayer = currentPlayer else { return }
        
        let cardType = cardTypes[currentCardIndex]
        let isCardOpened: Bool

        // Проверяем, открыта ли текущая карта
        switch cardType {
        case "profession": isCardOpened = currentPlayer.isProfessionOpened
        case "biology": isCardOpened = currentPlayer.isBiologyOpened
        case "health": isCardOpened = currentPlayer.isHealthOpened
        case "hobby": isCardOpened = currentPlayer.isHobbyOpened
        case "baggage": isCardOpened = currentPlayer.isBaggageOpened
        case "facts": isCardOpened = currentPlayer.isFactsOpened
        case "specialCondition": isCardOpened = currentPlayer.isSpecialConditionOpened
        default: isCardOpened = false
        }

        if isCardOpened {
            revealCardButton.setTitle("Card is opened", for: .normal)
            revealCardButton.isEnabled = false
        } else {
            revealCardButton.setTitle("Open the card", for: .normal)
            revealCardButton.isEnabled = true
        }
    }
}
