//
//  MainPresenter.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 02.06.2022.
//

import Foundation
import UIKit
protocol IMainPresenter: AnyObject {
    func setupView(data: [CoinModel], view: IMainView)
}

final class MainPresenter {
    private weak var view: IMainView?
}

extension MainPresenter: IMainPresenter {
    func setupView(data: [CoinModel], view: IMainView) {
        self.view = view
        view.setupCoinsList(coins: data)
    }
}
