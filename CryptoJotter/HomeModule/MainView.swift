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
    
    private var coins: [CoinModel]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var coinsBuffer: [CoinModel] = []
    
    var tapOnCell: ((CoinModel)->())?
    
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
        
        self.addSubview(self.tableView)
        self.tableView.backgroundColor = .clear
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.customSearchBar.bottomAnchor,constant: 20).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension MainView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coins?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainViewCell else { print("failed load cell"); return UITableViewCell()}
        guard let coins = self.coins else { return UITableViewCell()}
        cell.injectData(data: coins[indexPath.row], index: indexPath.row)
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

