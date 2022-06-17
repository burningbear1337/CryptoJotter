//
//  MainView.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 02.06.2022.
//

import UIKit

protocol IHomeView: AnyObject {
    func setupCoinsList(coins: [CoinModel]?)
    var tapOnCell: ((CoinModel)->())? { get set }
    var sortByRank: (()->())? { get set }
    var sortByPrice: (()->())? { get set }
    var reloadData: (()->())? { get set }
    var textFieldDataWorkflow: ((String) -> ())? { get set }
}

final class HomeView: UIView {
    
    private var customSearchBar = CustomSearchBar()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .singleLine
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
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

    private lazy var reloadDataButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "arrow.triangle.2.circlepath"), for: .normal)
        button.addTarget(self, action: #selector(reloadDataTapped), for: .touchUpInside)
        return button
    }()
    
    private var coins: [CoinModel]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var increaseByRank: Bool = true
    private var increaseByPrice: Bool = true
    
    var tapOnCell: ((CoinModel)->())?
    var sortByRank: (()->())?
    var sortByPrice: (()->())?
    var reloadData: (()->())?
    var textFieldDataWorkflow: ((String) -> ())?
    
    init() {
        super.init(frame: .zero)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView: IHomeView {
    
    func setupCoinsList(coins: [CoinModel]?) {
        self.coins = coins
    }
}

extension HomeView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coins?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else { print("failed load cell"); return UITableViewCell()}
        guard let coins = self.coins else { return UITableViewCell()}
        cell.injectData(coin: coins[indexPath.row])
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

extension HomeView: UITextFieldDelegate {
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let previousText:NSString = textField.text! as NSString
        let updatedText = previousText.replacingCharacters(in: range, with: string)
        self.textFieldDataWorkflow?(updatedText)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.textFieldDataWorkflow?("")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.textFieldDataWorkflow?("")
        return true
    }
}

extension HomeView: ISubscriber {
    func update(newData: [CoinModel]) {
        self.coins = newData
    }
}

private extension HomeView {
    func setupLayout() {
        self.backgroundColor = UIColor.theme.backgroundColor
        setupTableViewLayout()
    }
    
    func setupTableViewLayout() {
        self.customSearchBar.textField.delegate = self
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
        
        self.addSubview(self.reloadDataButton)
                NSLayoutConstraint.activate([
                    self.reloadDataButton.centerYAnchor.constraint(equalTo: self.filterByRankButton.centerYAnchor),
                    self.reloadDataButton.trailingAnchor.constraint(equalTo: self.filterByPriceButton.leadingAnchor, constant: -10)
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
    }
    
    @objc func sortByPriceTapped() {
        self.sortByPrice?()
    }
    
    @objc func reloadDataTapped() {
        self.reloadData?()
    }
}
