//
//  MainRouter.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 02.06.2022.
//

import UIKit

protocol IMainRouter: AnyObject {
    func routeToDetails(_ vc: UIViewController, coin: CoinModel)
    var data: CoinModel? { get set }
}

final class MainRouter {
    var data: CoinModel?
}

extension MainRouter: IMainRouter  {
    
    func routeToDetails(_ vc: UIViewController, coin: CoinModel) {
        vc.present(DetailsModuleBuilder().routeCoinToNextViewController(coin: coin).build(), animated: true)
    }
}

