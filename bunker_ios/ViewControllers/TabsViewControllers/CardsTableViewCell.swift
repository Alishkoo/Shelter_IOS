


import UIKit
import Kingfisher

class CardTableViewCell: UITableViewCell {
    static let identifier = "CardTableViewCell"

    private let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cardImageView)

        NSLayoutConstraint.activate([
            cardImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with player: PlayerWithCard, cardType: String) {
        let card: Card?
        switch cardType {
        case "profession":
            card = player.profession
        case "biology":
            card = player.biology
        case "health":
            card = player.health
        case "hobby":
            card = player.hobby
        case "baggage":
            card = player.baggage
        case "facts":
            card = player.facts
        case "specialCondition":
            card = player.specialCondition
        default:
            card = nil
        }

        if let card = card {
            cardImageView.kf.setImage(with: URL(string: card.imageUrl))
        } else {
            cardImageView.image = nil
        }
    }
}
