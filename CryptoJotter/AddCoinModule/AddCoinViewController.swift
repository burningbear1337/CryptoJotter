//
//  AddCoinViewController.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 15.06.2022.
//

import UIKit

class AddCoinViewController: UIViewController {
    
    private let presenter: IAddCoinPresenter
    private let customView = AddCoinView()
    
    init(presenter: IAddCoinPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.sinkDataToView(view: self.customView)
        self.view.backgroundColor = UIColor.theme.backgroundColor
    }
}
