//
//  PortfolioPresenter.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 08.06.2022.
//

import Foundation

protocol IPortfolioPresenter: AnyObject {
    func setData(coins: [CoinModel], view: IPortfolioView)
}

final class PortfolioPresenter {
    private weak var view: IPortfolioView?
}

extension PortfolioPresenter: IPortfolioPresenter {
    func setData(coins: [CoinModel], view: IPortfolioView) {
        self.view = view
        view.setData(coins: coins)
    }
}
