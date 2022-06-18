//
//  PortfolioPresenter.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 08.06.2022.
//

import UIKit

protocol IPortfolioPresenter: AnyObject {
    func sinkDataToView(view: IPortfolioView)
    func addNewCoin(vc: UIViewController)
}

final class PortfolioPresenter {
    
    private weak var view: IPortfolioView?
    private var router: IPortfolioRouter
    private var coreDataUtility: ICoreDataUtility
    
    var addNewCoin: (()->())?
    
    init(router: IPortfolioRouter, coreDataUtility: ICoreDataUtility) {
        self.router = router
        self.coreDataUtility = coreDataUtility
    }
}

extension PortfolioPresenter: IPortfolioPresenter {
    
    func sinkDataToView(view: IPortfolioView) {
        self.view = view
        self.coreDataUtility.fetchPortfolio { coinItems in
            view.fetchCoins(coins: coinItems)
        }
    }
    
    func addNewCoin(vc: UIViewController) {
        self.router.presentVC(vc: vc)
    }
}
