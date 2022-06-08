//
//  DetailsPresenter.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 07.06.2022.
//

import Foundation
import UIKit

protocol IDetailsPresenter: AnyObject {
    func setupView(coin: CoinModel?, view: IDetailsView)
    func setupViewWithDetails(coinDetails: CoinDetailsModel?, view: IDetailsView)
}

final class DetailsPresenter {
    weak var view: IDetailsView?
}

extension DetailsPresenter: IDetailsPresenter {

    func setupView(coin: CoinModel?, view: IDetailsView) {
        self.view = view
        view.setCoins(coin: coin)
    }
    
    func setupViewWithDetails(coinDetails: CoinDetailsModel?, view: IDetailsView) {
        self.view = view
        view.setCoinsDetailsData(coinDetails: coinDetails)
    }
}
