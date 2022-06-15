//
//  MainView.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 02.06.2022.
//

import UIKit

protocol IMainView: AnyObject {
    func setupCoinsList(coins: [CoinModel]?)
    var tapOnCell: ((CoinModel)->())? { get set }
    var sortByRank: (()->())? { get set }
    var sortByPrice: (()->())? { get set }
}

final class MainView: UIView {
    
    lazy var customSearchBar: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Type coin name...",
            attributes: [
                NSAttributedString.Key.font : AppFont.semibold15.font as Any,
                NSAttributedString.Key.foregroundColor: UIColor.theme.secondaryColor as Any
            ]
        )
        textField.backgroundColor = UIColor.theme.backgroundColor
        textField.layer.cornerRadius = 10
        
        let emptyView = UIView(frame: .init(x: .zero, y: .zero, width: 16, height: .zero))
        textField.clearButtonMode = .always
        textField.leftViewMode = .always
        textField.leftView = emptyView
        textField.rightViewMode = .always
        textField.returnKeyType = .search
        textField.autocorrectionType = .no
        textField.layer.shadowColor = UIColor.theme.shadowColor?.cgColor
        textField.layer.shadowOpacity = 0.1
        textField.layer.shadowRadius = 8
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
        textField.delegate = self
        return textField
    }()

    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .singleLine
        tableView.register(MainViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private lazy var filterByRankButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Rank", for: .normal)
        button.titleLabel?.font = AppFont.regular13.font
        button.setTitleColor(UIColor.theme.greenColor, for: .normal)
        button.addTarget(self, action: #selector(sortByRankTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var filterByPriceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Price", for: .normal)
        button.titleLabel?.font = AppFont.regular13.font
        button.setTitleColor(UIColor.theme.greenColor, for: .normal)
        button.addTarget(self, action: #selector(sortByPriceTapped), for: .touchUpInside)
        return button
    }()

    
    private var coins: [CoinModel]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var coinsBuffer: [CoinModel] = []
    
    private var increaseByRank: Bool = true
    private var increaseByPrice: Bool = true
    
    var tapOnCell: ((CoinModel)->())?
    var sortByRank: (()->())?
    var sortByPrice: (()->())?

    
    init() {
        super.init(frame: .zero)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainView: IMainView {
    
    func setupCoinsList(coins: [CoinModel]?) {
        self.coins = coins
    }
}

extension MainView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coins?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainViewCell else { print("failed load cell"); return UITableViewCell()}
        guard let coins = self.coins else { return UITableViewCell()}
        cell.injectData(coin: coins[indexPath.row], index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let coins = self.coins else { return }
        self.tapOnCell?(coins[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

extension MainView: UITextFieldDelegate {
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.coinsBuffer = self.coins ?? []
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            self.coins = self.coinsBuffer
            self.coins = self.coins?.filter({
                guard let text = textField.text?.uppercased() else { return true }
                let symbol = $0.symbol.uppercased()
                let name = $0.name.uppercased()
                return ((symbol.contains(text)) || (name.contains(text)))
            })
        } else {
            self.coins = self.coinsBuffer
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.coins = self.coinsBuffer
        print(self.coins?.count as Any)
        return true
    }
}

private extension MainView {
    func setupLayout() {
        self.backgroundColor = UIColor.theme.backgroundColor
        setupTableViewLayout()
    }
    
    func setupTableViewLayout() {
        self.addSubview(self.customSearchBar)
        self.customSearchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.customSearchBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.customSearchBar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.customSearchBar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.customSearchBar.heightAnchor.constraint(equalToConstant: 55),
        ])
        
        self.addSubview(self.filterByRankButton)
        NSLayoutConstraint.activate([
            self.filterByRankButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.filterByRankButton.topAnchor.constraint(equalTo: self.customSearchBar.bottomAnchor, constant: 10),
        ])
        
        self.addSubview(self.filterByPriceButton)
        NSLayoutConstraint.activate([
            self.filterByPriceButton.centerYAnchor.constraint(equalTo: self.filterByRankButton.centerYAnchor),
            self.filterByPriceButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        self.addSubview(self.tableView)
        self.tableView.backgroundColor = .clear
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.filterByRankButton.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc func sortByRankTapped() {
        self.sortByRank?()
//        if self.increaseByRank {
//            self.coins = self.coins?.sorted(by: { $0.marketCapRank ?? 0 > $1.marketCapRank ?? 0})
//            self.increaseByRank.toggle()
//        } else if !self.increaseByRank {
//            self.coins = self.coins?.sorted(by: { $0.marketCapRank ?? 0 < $1.marketCapRank ?? 0})
//            self.increaseByRank.toggle()
//        }
    }
    
    @objc func sortByPriceTapped() {
        self.sortByPrice?()
//        if self.increaseByPrice {
//            self.coins = self.coins?.sorted(by: {$0.currentPrice > $1.currentPrice })
//            self.increaseByPrice.toggle()
//        } else if !self.increaseByPrice {
//            self.coins = self.coins?.sorted(by: {$0.currentPrice < $1.currentPrice })
//            self.increaseByPrice.toggle()
//        }
    }
}
