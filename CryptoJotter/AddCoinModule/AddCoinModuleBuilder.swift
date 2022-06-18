//
//  AddCoinModuleBuilder.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 16.06.2022.
//

import UIKit

final class AddCoinModuleBuilder: IBuilder {
    func build() -> UIViewController {
        let networkService = NetworkService()
        let coreDataUtility = CoreDataUtility()
        let presenter = AddCoinPresenter(networkService: networkService, coreDataUtility: coreDataUtility)
        let vc = AddCoinViewController(presenter: presenter)
        return vc
    }
}
