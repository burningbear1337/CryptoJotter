//
//  MainViewController.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 02.06.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private let mainView = MainView()
    private let iteractor: IMainIteractor
    private let router: IMainRouter
    
    init(iteractor: IMainIteractor, router: IMainRouter) {
        self.iteractor = iteractor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.mainView
        self.title = "Live Prices"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.iteractor.loadAllCoinsTo(view: mainView)
        self.routeToNextVC()
    }
}

private extension MainViewController {
    func routeToNextVC() {
        self.mainView.tapOnCell = { [weak self] coin in
            guard let self = self else { return}
            print("MainVC: \(coin.symbol)")
            self.router.routeToDetails(self, coin: coin)
        }
    }
}
