//
//  MainRouter.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 02.06.2022.
//

import UIKit

protocol IMainRouter: AnyObject {
    func routeToDetails(_ vc: UIViewController, coin: CoinModel)
}

final class MainRouter: IMainRouter {
    func routeToDetails(_ vc: UIViewController, coin: CoinModel) {
        vc.present(DetailsModuleBuilder().routeCoinToNextViewController(coin: coin).build(), animated: true)
    }
}
