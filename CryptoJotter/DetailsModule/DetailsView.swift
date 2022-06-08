//
//  DetailsView.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 07.06.2022.
//

import UIKit

protocol IDetailsView: AnyObject {
    func setData(data: CoinModel?)
}

final class CustomDetailsView: UIView {
    
    private var data: CoinModel?
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.theme.accentColor
        label.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CustomDetailsView {
    
    func setupLayout() {
        self.addSubview(self.label)
    }
}

extension CustomDetailsView: IDetailsView {
    func setData(data: CoinModel?) {
        print("view: \(data?.symbol)")
        self.data = data
        self.label.text = data?.symbol
    }
}
