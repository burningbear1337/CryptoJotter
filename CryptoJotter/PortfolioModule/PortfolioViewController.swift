//
//  PortfolioViewController.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 07.06.2022.
//

import UIKit

class PortfolioViewController: UIViewController {
    
    private lazy var portfolioView = PortfolioView(vc: self)
    private var presenter: IPortfolioPresenter
    
    init(presenter: IPortfolioPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.portfolioView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.theme.backgroundColor
        self.title = "Your Portfolio"
        self.setupLayout()
        self.presenter.sinkDataToView(view: self.portfolioView)
    }
}

private extension PortfolioViewController {
    
    func setupLayout() {
        self.setupNav()
    }
    
    func setupNav() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.app"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(addCoinTapped))
    }
    
    @objc func addCoinTapped() {
        self.presenter.addNewCoin(vc: self)
    }
}
