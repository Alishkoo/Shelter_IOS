

import UIKit

class OtherPlayersViewController: UIViewController {
    var gameData: GameStartedData? {
        didSet {
            guard let gameData = gameData else {
                print("gameData is nil")
                return
            }

            filterPlayers()
            tableView.reloadData()
        }
    }
    
    private var otherPlayers: [PlayerWithCard] = []
    
    // TableView
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(OtherPlayerCell.self, forCellReuseIdentifier: OtherPlayerCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupTableView()
        setupNotificationListener() // Устанавливаем слушатель события
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Фильтруем игроков
    private func filterPlayers() {
        guard let gameData = gameData else { return }
        let currentPlayerId = UserDefaults.standard.string(forKey: "playerId") ?? ""
        
        // Оставляем только игроков, кроме текущего
        otherPlayers = gameData.players.filter { $0.id != currentPlayerId }
    }
    
    // MARK: - Устанавливаем слушатель NotificationCenter
    private func setupNotificationListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleCardOpened(_:)), name: Notification.Name("card-opened"), object: nil)
    }
    
    @objc private func handleCardOpened(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            print("No userInfo found in notification")
            return
        }
        
        do {
            // Конвертируем userInfo в Data
            let jsonData = try JSONSerialization.data(withJSONObject: userInfo, options: [])
            // Декодируем данные в GameStartedData
            let updatedGameData = try JSONDecoder().decode(Lobby.self, from: jsonData)
            
            print("card is opened \(updatedGameData)")
            
            // Обновляем только lobby в gameData
                   if var currentGameData = self.gameData {
                       currentGameData.lobby = updatedGameData
                       self.gameData = currentGameData
                       
                       // Перезагружаем таблицу
                       DispatchQueue.main.async { [weak self] in
                           self?.filterPlayers() // Фильтруем игроков после обновления
                           self?.tableView.reloadData() // Обновляем интерфейс
                       }
                       
                       print("Lobby updated after card-opened event")
                    
                   } else {
                       print("No current gameData to update lobby")
                   }
        } catch {
            print("Failed to decode card-opened notification: \(error)")
        }
    }
    
    deinit {
        // Удаляем слушатель
        NotificationCenter.default.removeObserver(self, name: Notification.Name("card-opened"), object: nil)
    }
}

extension OtherPlayersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherPlayerCell.identifier, for: indexPath) as? OtherPlayerCell else {
            return UITableViewCell()
        }
        
        let player = otherPlayers[indexPath.row]
        cell.configure(with: player, lobby: gameData!.lobby)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
