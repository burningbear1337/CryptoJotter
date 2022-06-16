//
//  MainModuleBuilder.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 02.06.2022.
//


import UIKit

protocol IBuilder: AnyObject {
    func build() -> UIViewController
}

final class HomeModuleBuilder: IBuilder {
    func build() -> UIViewController {
        let networkService = NetworkService()
        let router = HomeRouter()
        let presenter = HomePresenter(networkService: networkService, router: router)
        let vc = HomeViewController(presenter: presenter)
        return vc
    }
}
