//
//  PortfolioRouter.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 08.06.2022.
//

import UIKit

protocol IPortfolioRouter: AnyObject {
    func presentVC(vc: UIViewController)
}

final class PortfolioRouter: IPortfolioRouter {
    func presentVC(vc: UIViewController) {
        vc.present(AddCoinViewController(), animated: true)
    }
}
