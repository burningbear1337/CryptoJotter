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
        print("Builder: \(self.coin?.symbol)")
        let presenter = DetailsPresenter()
        let iteractor = DetailsIteractor(presenter: presenter)
        let vc = DetailsViewController(iteractor: iteractor, coin: self.coin)
        return vc
    }
}
