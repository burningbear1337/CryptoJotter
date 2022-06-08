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
        let presenter = MainPresenter()
        let iteractor = MainIteractor(presenter: presenter)
        let router = MainRouter()
        let vc = MainViewController(iteractor: iteractor, router: router)
        return vc
    }
}
