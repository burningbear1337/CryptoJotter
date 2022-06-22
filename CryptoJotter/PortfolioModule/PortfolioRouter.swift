//
//  PortfolioRouter.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 08.06.2022.
//

import UIKit

protocol IPortfolioRouter: AnyObject {
    func routeToAddCoinViewController(vc: UIViewController)
    func routeToDetailsViewController(vc: UIViewController, coin: CoinModel)
}

final class PortfolioRouter: IPortfolioRouter {
    func routeToDetailsViewController(vc: UIViewController, coin: CoinModel) {
        vc.present(DetailsModuleBuilder().routeCoinToNextViewController(coin: coin).build(), animated: true)
    }
    
    func routeToAddCoinViewController(vc: UIViewController) {
        vc.navigationController?.pushViewController(AddCoinModuleBuilder().build(), animated: true)
    }
    
    
}
