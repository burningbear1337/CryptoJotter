//
//  MainIteractor.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 05.06.2022.
//

import Foundation

protocol IMainIteractor: AnyObject {
    func loadAllCoinsTo(view: IMainView)
}

final class MainIteractor {
    
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    private var presenter: IMainPresenter
    private var networkManager = NetworkManager()
    
    init(presenter: IMainPresenter) {
        self.presenter = presenter
    }
}

extension MainIteractor: IMainIteractor {
    
    func loadAllCoinsTo(view: IMainView) {
        self.networkManager.fetchArrayOfData(urlsString: self.urlString) { (result: Result<[CoinModel],Error>) in
            switch result {
            case .success(let allCoins):
                DispatchQueue.main.async {
                    self.presenter.setupView(data: allCoins, view: view)
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
}
