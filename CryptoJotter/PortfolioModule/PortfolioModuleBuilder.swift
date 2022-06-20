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
        let networkService = NetworkService()
        let presenter = PortfolioPresenter(router: router, coreDataUtility: coreDataUtility, networkService: networkService)
        let vc = PortfolioViewController(presenter: presenter)
        return vc
    }
}
