//
//  MainRouter.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 02.06.2022.
//

import UIKit

protocol IHomeRouter: AnyObject {
    
    func routeToDetails(_ vc: UIViewController, coin: CoinModel)
}

final class HomeRouter: IHomeRouter {
    
    func routeToDetails(_ vc: UIViewController, coin: CoinModel) {
        let nextVC = DetailsModuleBuilder().routeCoinToNextViewController(coin: coin).build()
        nextVC.modalTransitionStyle = .flipHorizontal
        vc.present(nextVC, animated: true)
    }
}
