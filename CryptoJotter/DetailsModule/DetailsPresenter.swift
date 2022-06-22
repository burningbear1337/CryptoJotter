//
//  DetailsPresenter.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 07.06.2022.
//

import Foundation
import UIKit

protocol IDetailsPresenter: AnyObject {
    func sinkDataToView(view: IDetailsView)
}

final class DetailsPresenter {
    weak var view: IDetailsView?
    private var networkService: INetworkService
    private var coin: CoinModel
    
    init(networkService: INetworkService, coin: CoinModel) {
        self.networkService = networkService
        self.coin = coin
    }
}

extension DetailsPresenter: IDetailsPresenter {

    func sinkDataToView(view: IDetailsView) {
        self.view = view
        view.setupCoins(coin: self.coin)
        let urlString = urlForCoin(coin: self.coin)
        print(urlString)
        self.networkService.fetchCoinData(urlsString: urlString) { (result: Result<CoinDetailsModel?, Error>) in
            switch result {
            case .success(let details):
                view.setCoinsDetailsData(coinDetails: details)
            case .failure(let error):
                print(error)
            }
        }

    }
}

private extension DetailsPresenter {
    func urlForCoin(coin: CoinModel?) -> String {
        guard let coin = coin?.name?.lowercased() else { return "" }
        return "https://api.coingecko.com/api/v3/coins/\(coin)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
    }
}
