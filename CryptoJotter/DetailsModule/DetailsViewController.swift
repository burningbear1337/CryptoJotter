//
//  DetailsViewController.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 07.06.2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private let customDetailsView = CustomDetailsView()
    private var iteractor: IDetailsIteractor
    private var coin: CoinModel?
        
    init(iteractor: IDetailsIteractor, coin: CoinModel?) {
        self.iteractor = iteractor
        self.coin = coin
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
        self.iteractor.transferData(view: self.customDetailsView, coin: self.coin)
        self.iteractor.fetchDetailsData(view: self.customDetailsView)
        self.view.backgroundColor = UIColor.theme.backgroundColor
    }
}
