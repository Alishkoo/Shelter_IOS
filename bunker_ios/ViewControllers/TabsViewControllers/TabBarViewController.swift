

import UIKit

class TabBarViewController: UITabBarController {
    
    var gameData: GameStartedData? {
        didSet {
            guard let gameData = gameData else {
                print("Lobby is nil")
                return
            }
//            print("Lobby received: \(lobby)")
            updateTabBarControllers()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupTabBar()
        
        view.backgroundColor = .white
    }
    
    private func setupTabBar() {
        // Создаем три вкладки
        let cardsVC = CardsViewController()
        let bunkerVC = BunkerCardsViewController()
        let otherPlayersVC = OtherPlayersViewController()
            
        cardsVC.tabBarItem = UITabBarItem(title: "Cards", image: UIImage(systemName: "rectangle.stack"), tag: 0)
        bunkerVC.tabBarItem = UITabBarItem(title: "Bunker", image: UIImage(systemName: "house"), tag: 1)
        otherPlayersVC.tabBarItem = UITabBarItem(title: "Players", image: UIImage(systemName: "person.3"), tag: 2)
            
        self.viewControllers = [cardsVC, bunkerVC, otherPlayersVC]
    }
    
    private func updateTabBarControllers() {
            guard let viewControllers = self.viewControllers else { return }
            
           
            for viewController in viewControllers {
                if let cardsVC = viewController as? CardsViewController {
                    cardsVC.gameData = gameData
                } else if let bunkerVC = viewController as? BunkerCardsViewController {
            
                } else if let otherPlayersVC = viewController as? OtherPlayersViewController {
                    
                }
            }
    }


   

}
