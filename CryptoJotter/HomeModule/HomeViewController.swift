//
//  MainViewController.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 02.06.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let mainView = HomeView()
    private let presenter: IHomePresenter
    
    init(presenter: IHomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.mainView
        self.title = "Live Prices"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.sinkDataToView(view: self.mainView, vc: self)
    }
}

