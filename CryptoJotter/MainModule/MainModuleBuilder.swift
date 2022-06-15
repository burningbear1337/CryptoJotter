//
//  MainModuleBuilder.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 02.06.2022.
//


import UIKit

protocol Builder: AnyObject {
    func build() -> UIViewController
}

final class MainModuleBuilder: Builder {
    func build() -> UIViewController {
        let networkService = NetworkService()
        let router = MainRouter()
        let presenter = MainPresenter(networkService: networkService, router: router)
        let vc = MainViewController(presenter: presenter)
        return vc
    }
}
