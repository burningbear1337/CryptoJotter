//
//  MainView.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 02.06.2022.
//

import UIKit

protocol IHomeView: AnyObject {
    
    var tapOnCell: ((CoinModel)->())? { get set }
    var sortByRank: (()->(Bool))? { get set }
    var sortByPrice: (()->(Bool))? { get set }
    var reloadData: (()->())? { get set }
    var textFieldDataWorkflow: ((String) -> ())? { get set }
}

final class HomeView: UIView, IHomeView {
    
    private enum Constants {
        static let cellID = "cell"
        static let tableCellHeight: CGFloat = 60
        static let searchBarPadding: CGFloat = 20
        static let searchBarHeight: CGFloat = 55
        static let defaultPadding: CGFloat = 8
    }
    
    private var customSearchBar = CustomSearchBarView()
    
    private lazy var filtersPlateView = FiltersPlateView(showHoldings: false)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .singleLine
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: Constants.cellID)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private var coins: [CoinModel]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var tapOnCell: ((CoinModel)->())?
    var sortByRank: (()->(Bool))?
    var sortByPrice: (()->(Bool))?
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

extension HomeView: ISubscriber {
    
    func update(newData: [CoinModel]) {
        self.coins = newData
    }
}

extension HomeView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coins?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as? CustomTableViewCell else { return UITableViewCell()}
        guard let coin = coins?[indexPath.row] else { return UITableViewCell()}
        cell.injectCoinModel(coin: coin, holdings: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let coins = self.coins else { return }
        self.tapOnCell?(coins[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.tableCellHeight
    }
}

extension HomeView: UITextFieldDelegate {
        
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

private extension HomeView {
    
    func setupLayout() {
        self.backgroundColor = UIColor.theme.backgroundColor
        self.setupTableViewLayout()
    }
    
    func setupTableViewLayout() {
        self.customSearchBar.textField.delegate = self
        self.addSubview(self.customSearchBar)
        self.customSearchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.customSearchBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Constants.searchBarPadding),
            self.customSearchBar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constants.searchBarPadding),
            self.customSearchBar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.searchBarPadding),
            self.customSearchBar.heightAnchor.constraint(equalToConstant: Constants.searchBarHeight),
        ])
        
        self.addSubview(self.filtersPlateView)
        self.filtersPlateView.translatesAutoresizingMaskIntoConstraints = false
        self.filtersPlateView.filtersPlateViewDelegate = self
        NSLayoutConstraint.activate([
            self.filtersPlateView.topAnchor.constraint(equalTo: self.customSearchBar.bottomAnchor,constant: Constants.defaultPadding),
            self.filtersPlateView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.defaultPadding),
            self.filtersPlateView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.defaultPadding),
        ])
        
        self.addSubview(self.tableView)
        self.tableView.backgroundColor = .clear
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.filtersPlateView.bottomAnchor, constant: Constants.defaultPadding),
            self.tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
         
    }
}

extension HomeView: IFiltersPlateView {
    
    func filterByRank() -> Bool {
        guard let result = self.sortByRank?() else { return false }
        return result
    }
    
    func filterByPrice() -> Bool {
        guard let result = self.sortByPrice?() else { return false }
        return result
    }
    
    func filterByHoldings() -> Bool { false }
    
    func reloadCoinsList() { self.reloadData?() }
}
