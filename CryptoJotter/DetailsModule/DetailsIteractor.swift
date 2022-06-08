//
//  DetailsIteractor.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 07.06.2022.
//

import Foundation

protocol IDetailsIteractor: AnyObject {
    func dataTransitionTo(view: IDetailsView, coin: CoinModel?)
}

final class DetailsIteractor {
    
    private var presenter: IDetailsPresenter
    
    init(presenter: IDetailsPresenter) {
        self.presenter = presenter
    }
}

extension DetailsIteractor: IDetailsIteractor {
     
    func dataTransitionTo(view: IDetailsView, coin: CoinModel?) {
        self.presenter.setupView(data: coin, view: view)
    }
}
