//
//  DetailsViewController.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 07.06.2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private let customDetailsView = CustomDetailsView()
    private var presenter: IDetailsPresenter
        
    init(presenter: IDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.customDetailsView
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.sinkDataToView(view: self.customDetailsView)
        self.view.backgroundColor = UIColor.theme.backgroundColor
    }
}
