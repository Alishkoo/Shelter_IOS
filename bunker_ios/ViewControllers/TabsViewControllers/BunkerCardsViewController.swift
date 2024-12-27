


import UIKit

class BunkerCardsViewController: UIViewController {

    var lobby: Lobby?
    var players: [PlayerWithCard]?
    
    private let scrollView = UIScrollView()
    private let imageView1 = UIImageView()
    private let imageView2 = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        imageView1.image = UIImage(named: "ВИДЕО СО СПУТНИКА")
        imageView2.image = UIImage(named: "ВИДЕО СО СПУТНИКА")
    }

    private func setupView() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        scrollView.addSubview(imageView1)
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView1.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView1.widthAnchor.constraint(equalTo: scrollView.widthAnchor), // Привязка к scrollView
            imageView1.heightAnchor.constraint(equalTo: scrollView.heightAnchor) // Привязка к scrollView
        ])
        imageView1.contentMode = .scaleAspectFit

        scrollView.addSubview(imageView2)
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView2.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView2.leadingAnchor.constraint(equalTo: imageView1.trailingAnchor),
            imageView2.widthAnchor.constraint(equalTo: scrollView.widthAnchor), // Привязка к scrollView
            imageView2.heightAnchor.constraint(equalTo: scrollView.heightAnchor) // Привязка к scrollView
        ])
        imageView2.contentMode = .scaleAspectFit
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * 2, height: scrollView.bounds.height)
    }
}
