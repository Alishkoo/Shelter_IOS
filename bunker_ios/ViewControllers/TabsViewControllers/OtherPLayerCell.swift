

import UIKit
import Kingfisher

class OtherPlayerCell: UITableViewCell {
    static let identifier = "OtherPlayerCell"
    
    private let playerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Горизонтальный ScrollView для карт
    private let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = false
        return scrollView
    }()
    
    // StackView внутри ScrollView
    private let cardsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20 // Расстояние между картами
        stackView.distribution = .fill // Каждая карта сохраняет свои размеры
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(playerNameLabel)
        contentView.addSubview(horizontalScrollView)
        horizontalScrollView.addSubview(cardsStackView)
        
        NSLayoutConstraint.activate([
            // Имя игрока
            playerNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            playerNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            playerNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            // Горизонтальный ScrollView
            horizontalScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            horizontalScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            horizontalScrollView.topAnchor.constraint(equalTo: playerNameLabel.bottomAnchor, constant: 10),
            horizontalScrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            horizontalScrollView.heightAnchor.constraint(equalToConstant: 250), 
            
            // StackView внутри ScrollView
            cardsStackView.leadingAnchor.constraint(equalTo: horizontalScrollView.leadingAnchor),
            cardsStackView.trailingAnchor.constraint(equalTo: horizontalScrollView.trailingAnchor),
            cardsStackView.topAnchor.constraint(equalTo: horizontalScrollView.topAnchor),
            cardsStackView.bottomAnchor.constraint(equalTo: horizontalScrollView.bottomAnchor),
            cardsStackView.heightAnchor.constraint(equalTo: horizontalScrollView.heightAnchor)
        ])
    }
    
    func configure(with player: PlayerWithCard, lobby: Lobby) {
        playerNameLabel.text = player.name
        cardsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // Очищаем старые карты
        
        // Находим игрока в lobby
        guard let lobbyPlayer = lobby.players.first(where: { $0.id == player.id }) else {
            print("Player not found in lobby")
            return
        }
        
        // Добавляем только раскрытые карты
        let cards: [(Card?, Bool)] = [
            (player.profession, lobbyPlayer.isProfessionOpened),
            (player.biology, lobbyPlayer.isBiologyOpened),
            (player.health, lobbyPlayer.isHealthOpened),
            (player.hobby, lobbyPlayer.isHobbyOpened),
            (player.baggage, lobbyPlayer.isBaggageOpened),
            (player.facts, lobbyPlayer.isFactsOpened),
            (player.specialCondition, lobbyPlayer.isSpecialConditionOpened)
        ]
        
        for (card, isOpened) in cards {
            guard isOpened, let card = card else { continue }
            
            let cardImageView = UIImageView()
            cardImageView.contentMode = .scaleAspectFit
            cardImageView.clipsToBounds = true
            cardImageView.layer.cornerRadius = 8
            cardImageView.backgroundColor = .lightGray
            
            if let url = URL(string: card.imageUrl) {
                cardImageView.kf.setImage(with: url)
            } else {
                cardImageView.image = UIImage(named: "placeholder") // Заглушка
            }
            
            // Добавляем в StackView
            cardsStackView.addArrangedSubview(cardImageView)
            
            // Применяем ограничения для размеров карты
            NSLayoutConstraint.activate([
                cardImageView.widthAnchor.constraint(equalToConstant: 170), // Ширина карты
                cardImageView.heightAnchor.constraint(equalToConstant: 300) // Высота карты
            ])
        }
    }
}
