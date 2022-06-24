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
        let nextVC = DetailsModuleBuilder().routeCoinToNextViewController(coin: coin).build()
        nextVC.modalTransitionStyle = .flipHorizontal
        vc.present(nextVC, animated: true)
    }
    
    func routeToAddCoinViewController(vc: UIViewController) {
        let nextVC = AddCoinModuleBuilder().build()
        vc.navigationController?.pushViewController(nextVC, animated: true)
    }
}
