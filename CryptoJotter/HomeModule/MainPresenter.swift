//
//  MainPresenter.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 02.06.2022.
//

import Foundation
import UIKit

protocol IMainPresenter: AnyObject {
    func sinkDataToView(view: IMainView, vc: UIViewController)
}

final class MainPresenter {
    private weak var view: IMainView?
    private var networkService: INetworkService
    private var router: IMainRouter
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    
    init(networkService: INetworkService, router: IMainRouter) {
        self.networkService = networkService
        self.router = router
    }
}

extension MainPresenter: IMainPresenter {
    func sinkDataToView(view: IMainView, vc: UIViewController) {
        self.view = view
        self.networkService.fetchCoinsList(urlsString: urlString) { (result: Result<[CoinModel], Error>) in
            switch result {
            case .success(let coins):
                view.setupCoinsList(coins: coins)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        view.tapOnCell = { [weak self] coinModel in
            self?.router.routeToDetails(vc, coin: coinModel)
        }
    }
}
