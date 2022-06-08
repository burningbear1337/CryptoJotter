//
//  DetailsPresenter.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 07.06.2022.
//

import Foundation
import UIKit

protocol IDetailsPresenter: AnyObject {
    func setupView(data: CoinModel?, view: IDetailsView)
}

final class DetailsPresenter {
    weak var view: IDetailsView?
}

extension DetailsPresenter: IDetailsPresenter {
    func setupView(data: CoinModel?, view: IDetailsView) {
        self.view = view
        view.setData(data: data)
    }
}
