//
//  PortfolioView.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 07.06.2022.
//

import UIKit

protocol IPortfolioView: AnyObject {
    func fetchCoins(coins: [CoinItem]?)
}

final class PortfolioView: UIView {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "portfolioCell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var vc: UIViewController?
    
    private var coins: [CoinItem]? {
        didSet {
            self.tableView.reloadData()
        }
    }
        
    init(vc: UIViewController) {
        self.vc = vc
        super.init(frame: .zero)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PortfolioView: IPortfolioView {
    func fetchCoins(coins: [CoinItem]?) {
        self.coins = coins
    }
}

extension PortfolioView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.coins?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "portfolioCell", for: indexPath)
        cell.textLabel?.text = "Some coins"
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped on cell")
    }
}

private extension PortfolioView {
    func setupLayout() {
        self.backgroundColor = UIColor.theme.backgroundColor
        self.setupHoldingsLabel()
        self.setupTableView()
    }
    
    func setupHoldingsLabel() {
//        self.addSubview(self.holdingsLabel)
//        NSLayoutConstraint.activate([
//            self.holdingsLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
//            self.holdingsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//        ])
    }
    
    func setupTableView() {
        self.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
