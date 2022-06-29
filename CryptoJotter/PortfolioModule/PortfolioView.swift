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
    
    private enum Constants {
        static let cellID = "portfolioCell"
        
        static let tableCellHeight: CGFloat = 60
        static let searchBarPadding: CGFloat = 20
        static let searchBarHeight: CGFloat = 55
        static let defaultPadding: CGFloat = 16
        static let emptyPortfolioPadding: CGFloat = 20
        
        static let deleteImageName = "trash"
        static let editImageName = "pencil"
    }
    
    private var customSearchBar = CustomSearchBarView()
    
    private lazy var filtersPlateView = FiltersPlateView(showHoldings: true)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: Constants.cellID)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var vc: UIViewController?
    
    private lazy var emptyPortfolioText: UILabel = {
        let label = UILabel()
        label.text = "Nothing found here..."
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
                    UIView.animate(withDuration: 0.5, delay: 0) {
                        self.emptyPortfolioText.layer.opacity = 1
                    }
                    self.filtersPlateView.alpha = 0
                } else {
                    UIView.animate(withDuration: 0.5, delay: 0) {
                        self.filtersPlateView.alpha = 1
                        self.emptyPortfolioText.layer.opacity = 0
                    } 
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
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as? CustomTableViewCell else { return UITableViewCell()}
        guard let coin = coins?[indexPath.row] else { return UITableViewCell()}
        cell.injectCoinModel(coin: coin, holdings: self.coinItemHoldings?(coin))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let coin = coins?[indexPath.row] else { return }
        self.routeToDetails?(coin)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.tableCellHeight
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            guard let coin = self.coins?[indexPath.row] else { return }
            self.deleteCoinFromPortfolio?(coin)
        }
        delete.backgroundColor = UIColor.theme.redColor
        delete.image = UIImage(systemName: Constants.deleteImageName)
        
        let edit = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            guard let coin = self.coins?[indexPath.row] else { return }
            self.editCoinFromPortfolio?(coin)
        }
        edit.backgroundColor = UIColor.theme.secondaryBackgroundColor
        edit.image = UIImage(systemName: Constants.editImageName)
        
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
            self.customSearchBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Constants.searchBarPadding),
            self.customSearchBar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constants.searchBarPadding),
            self.customSearchBar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.searchBarPadding),
            self.customSearchBar.heightAnchor.constraint(equalToConstant: Constants.searchBarHeight),
        ])
    }
    
    func setupFilters() {
        self.filtersPlateView.filtersPlateViewDelegate = self
        self.addSubview(self.filtersPlateView)
        self.filtersPlateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.filtersPlateView.topAnchor.constraint(equalTo: self.customSearchBar.bottomAnchor,constant: Constants.defaultPadding),
            self.filtersPlateView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.defaultPadding),
            self.filtersPlateView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.defaultPadding),
        ])
    }
    
    func setupTableView() {
        self.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.filtersPlateView.bottomAnchor, constant: Constants.defaultPadding),
            self.tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setupEmptyLabel() {
        self.addSubview(self.emptyPortfolioText)
        self.emptyPortfolioText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.emptyPortfolioText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.emptyPortfolioPadding),
            self.emptyPortfolioText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.emptyPortfolioPadding),
            self.emptyPortfolioText.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}

extension PortfolioView: IFiltersPlateView {
    func filterByRank() -> Bool {
        guard let result = self.sortByRank?() else { return false }
        return result
    }
    
    func filterByPrice() -> Bool {
        guard let result = self.sortByPrice?() else { return false }
        return result
    }
    
    func filterByHoldings() -> Bool {
        guard let result = self.sortByHoldings?() else { return false }
        return result
    }
    
    func reloadCoinsList() {}
}


