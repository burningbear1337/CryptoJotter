//
//  PortfolioIntercator.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 08.06.2022.
//

import Foundation

protocol IPortfolioIntercator: AnyObject {
    func loadCoins(view: IPortfolioView)
}

final class PortfolioIteractor {
    private var presenter: IPortfolioPresenter
    
    init(presenter: IPortfolioPresenter) {
        self.presenter = presenter
    }
}

extension PortfolioIteractor: IPortfolioIntercator {
    func loadCoins(view: IPortfolioView) {
    
    }
}

private extension PortfolioIteractor {
    
}
