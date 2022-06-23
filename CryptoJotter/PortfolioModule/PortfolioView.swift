//
//  PortfolioView.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 07.06.2022.
//

import UIKit

protocol IPortfolioView: AnyObject {
    
    var textFieldDataWorkflow: ((String) -> ())? { get set }
    var coinItemHoldings: ((CoinModel)->(String?))? { get set }
    var deleteCoinFromPortfolio: ((CoinModel)->())? { get set }
    var editCoinFromPortfolio:((CoinModel)->())? { get set }
    var routeToDetails: ((CoinModel)->())? { get set }
    var sortByRank: (()->(Bool))? { get set }
    var sortByHoldings: (()->(Bool))? { get set }
    var sortByPrice: (()->(Bool))? { get set }
}

final class PortfolioView: UIView, IPortfolioView {
    
    private var customSearchBar = CustomSearchBarView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "portfolioCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var vc: UIViewController?
    
    private lazy var filterByRankButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Rank ▼", for: .normal)
        button.titleLabel?.font = AppFont.regular13.font
        button.setTitleColor(UIColor.theme.greenColor, for: .normal)
        button.addTarget(self, action: #selector(sortByRankTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var filterByHoldingsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Holdings", for: .normal)
        button.titleLabel?.font = AppFont.regular13.font
        button.setTitleColor(UIColor.theme.greenColor, for: .normal)
        button.addTarget(self, action: #selector(sortByHoldingsTapped), for: .touchUpInside)
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
    
    private lazy var emptyPortfolioText: UILabel = {
        let label = UILabel()
        label.text = "Your portfolio is empty!\n\n Start adding some coins you are interested in!"
        label.textColor = UIColor.theme.accentColor
        label.textAlignment = .center
        label.font = AppFont.semibold17.font
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var coins: [CoinModel]? {
        didSet {
            DispatchQueue.main.async {
                if self.coins?.count == 0 {
                    self.emptyPortfolioText.layer.opacity = 1
                } else {
                    self.emptyPortfolioText.layer.opacity = 0
                }
                self.tableView.reloadData()
            }
        }
    }
    
    var textFieldDataWorkflow: ((String) -> ())?
    var coinItemHoldings: ((CoinModel)->(String?))?
    var deleteCoinFromPortfolio: ((CoinModel)->())?
    var editCoinFromPortfolio:((CoinModel)->())?
    var routeToDetails: ((CoinModel)->())?
    var sortByRank: (()->(Bool))?
    var sortByHoldings: (()->(Bool))?
    var sortByPrice: (()->(Bool))?
    
    init(vc: UIViewController) {
        self.vc = vc
        super.init(frame: .zero)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PortfolioView: ISubscriber {
    
    func update(newData: [CoinModel]) {
        self.coins = newData
    }
}

extension PortfolioView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.coins?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "portfolioCell", for: indexPath) as? CustomTableViewCell else { return UITableViewCell()}
        guard let coin = coins?[indexPath.row] else { return UITableViewCell()}
        cell.injectCoinModel(coin: coin, holdings: self.coinItemHoldings?(coin))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let coin = coins?[indexPath.row] else { return }
        self.routeToDetails?(coin)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            guard let coin = self.coins?[indexPath.row] else { return }
            self.deleteCoinFromPortfolio?(coin)
        }
        delete.backgroundColor = UIColor.theme.redColor
        delete.image = UIImage(systemName: "trash")
        
        let edit = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            guard let coin = self.coins?[indexPath.row] else { return }
            self.editCoinFromPortfolio?(coin)
        }
        edit.backgroundColor = UIColor.theme.secondaryBackgroundColor
        edit.image = UIImage(systemName: "pencil")
        
        let actions = UISwipeActionsConfiguration(actions: [delete, edit])
        
        return actions
    }
}

extension PortfolioView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let previousText:NSString = textField.text! as NSString
        let updatedText = previousText.replacingCharacters(in: range, with: string)
        self.textFieldDataWorkflow?(updatedText)
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

private extension PortfolioView {
    
    func setupLayout() {
        self.backgroundColor = UIColor.theme.backgroundColor
        self.setupSearchBar()
        self.setupFilters()
        self.setupTableView()
        self.setupEmptyLabel()
    }
    
    
    func setupSearchBar() {
        self.customSearchBar.textField.delegate = self
        self.customSearchBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.customSearchBar)
        NSLayoutConstraint.activate([
            self.customSearchBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.customSearchBar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.customSearchBar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.customSearchBar.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
    
    func setupFilters() {
        self.addSubview(self.filterByRankButton)
        NSLayoutConstraint.activate([
            self.filterByRankButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            self.filterByRankButton.topAnchor.constraint(equalTo: self.customSearchBar.bottomAnchor, constant: 8)
        ])
        
        self.addSubview(self.filterByHoldingsButton)
        NSLayoutConstraint.activate([
            self.filterByHoldingsButton.leadingAnchor.constraint(equalTo: self.centerXAnchor),
            self.filterByHoldingsButton.centerYAnchor.constraint(equalTo: self.filterByRankButton.centerYAnchor)
        ])
        
        self.addSubview(self.filterByPriceButton)
        NSLayoutConstraint.activate([
            self.filterByPriceButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            self.filterByPriceButton.centerYAnchor.constraint(equalTo: self.filterByRankButton.centerYAnchor)
        ])
    }
    
    func setupTableView() {
        self.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.filterByRankButton.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setupEmptyLabel() {
        self.addSubview(self.emptyPortfolioText)
        self.emptyPortfolioText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.emptyPortfolioText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.emptyPortfolioText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.emptyPortfolioText.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    @objc func sortByRankTapped() {
        self.sortByRank?() == true ?
        self.filterByRankButton.setTitle("Rank ▲", for: .normal) :
        self.filterByRankButton.setTitle("Rank ▼", for: .normal)
        self.filterByPriceButton.setTitle("Price", for: .normal)
        self.filterByHoldingsButton.setTitle("Holdings", for: .normal)
    }
    
    
    @objc func sortByPriceTapped() {
        self.sortByPrice?() == true ?
        self.filterByPriceButton.setTitle("Price ▼", for: .normal) :
        self.filterByPriceButton.setTitle("Price ▲", for: .normal)
        self.filterByRankButton.setTitle("Rank", for: .normal)
        self.filterByHoldingsButton.setTitle("Holdings", for: .normal)
    }
    
    @objc func sortByHoldingsTapped() {
        self.sortByHoldings?() == true ?
        self.filterByHoldingsButton.setTitle("Holdings ▲", for: .normal) :
        self.filterByHoldingsButton.setTitle("Holdings ▼", for: .normal)
        self.filterByPriceButton.setTitle("Price", for: .normal)
        self.filterByRankButton.setTitle("Rank", for: .normal)
    }
}


