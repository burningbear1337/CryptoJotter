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
        let presenter = AddCoinPresenter(networkService: networkService)
        let vc = AddCoinViewController(presenter: presenter)
        return vc
    }
}
