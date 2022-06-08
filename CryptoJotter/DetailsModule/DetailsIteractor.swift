//
//  DetailsIteractor.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 07.06.2022.
//

import Foundation

protocol IDetailsIteractor: AnyObject {
    func transferData(view: IDetailsView, coin: CoinModel?)
    func fetchDetailsData(view: IDetailsView)
}

final class DetailsIteractor {
    
    private var presenter: IDetailsPresenter
    private var networkManager = NetworkManager()
    private var coin: CoinModel?
    
    init(presenter: IDetailsPresenter) {
        self.presenter = presenter
    }
}

extension DetailsIteractor: IDetailsIteractor {
    
    func transferData(view: IDetailsView, coin: CoinModel?) {
        self.coin = coin
        self.presenter.setupView(coin: coin, view: view)
    }
    
    func getUrlForCoin(coin: CoinModel?) -> String {
        guard let coin = coin else { return ""}
        return "https://api.coingecko.com/api/v3/coins/\(coin.name.lowercased())?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
    }
    
    func fetchDetailsData(view: IDetailsView) {
        let url = getUrlForCoin(coin: self.coin)
        print(url)
        self.networkManager.fetchDataElement(urlsString: url) { (result: Result<CoinDetailsModel?, Error>) in
            switch result {
            case .success(let coinDetails):
                print("Iteractor \(coinDetails?.name)")
                self.presenter.setupViewWithDetails(coinDetails: coinDetails, view: view)
            case .failure(let error):
                print(error)
            }
        }
    }
}
