//
//  PortfolioView.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 07.06.2022.
//

import UIKit

protocol IPortfolioView: AnyObject {
    func setData(coins: [CoinModel]?)
}

final class PortfolioView: UIView {
    private var coins = [CoinModel]()
}

extension PortfolioView: IPortfolioView {
    func setData(coins: [CoinModel]?) {
        
    }
}

private extension PortfolioView {
    
}
