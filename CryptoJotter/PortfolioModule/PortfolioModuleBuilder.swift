//
//  PortfolioModuleBuilder.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 15.06.2022.
//

import UIKit

final class PortfolioBuilder: IBuilder {
    func build() -> UIViewController {
        let router = PortfolioRouter()
        let coreDataUtility = CoreDataUtility()
        let presenter = PortfolioPresenter(router: router, coreDataUtility: coreDataUtility)
        let vc = PortfolioViewController(presenter: presenter)
        return vc
    }
}
