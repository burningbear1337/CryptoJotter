//
//  DetailsModuleBuilder.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 07.06.2022.
//

import UIKit

protocol IDetailsBuilder: AnyObject {
    
    func build() -> UIViewController
}

final class DetailsModuleBuilder: IDetailsBuilder {
    
    var coin: CoinModel?

    func routeCoinToNextViewController(coin: CoinModel?) -> IDetailsBuilder {
        self.coin = coin
        return self
    }
    
    func build() -> UIViewController {
        guard let coin = coin else { return UIViewController() }
        let networkService = NetworkService()
        let presenter = DetailsPresenter(networkService: networkService, coin: coin)
        let vc = DetailsViewController(presenter: presenter)
        return vc
    }
}
