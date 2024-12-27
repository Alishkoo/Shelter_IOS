

import UIKit

class SpinnerManager {
    static let shared = SpinnerManager()
    
    private var spinner: UIActivityIndicatorView?
    
    private init() {}
    
    func showSpinner(on view: UIView) {
        // Проверяем, нет ли уже активного спиннера
        guard spinner == nil else { return }
        
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .gray
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        self.spinner = spinner
        view.isUserInteractionEnabled = false // Блокируем UI
    }
    
    func hideSpinner() {
        spinner?.stopAnimating()
        spinner?.removeFromSuperview()
        spinner?.superview?.isUserInteractionEnabled = true // Разблокируем UI
        spinner = nil
    }
}
