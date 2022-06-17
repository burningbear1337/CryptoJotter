//
//  AddCoinView.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 16.06.2022.
//

import UIKit

protocol IAddCoinView: AnyObject {
    func sinkDataToView(coins: [CoinModel])
    var textFieldDataWorkflow: ((String) -> ())? { get set }
}

final class AddCoinView: UIView {
    
    private lazy var customSearchBar = CustomSearchBar()
    private lazy var collectionView = UICollectionView()
    
    var textFieldDataWorkflow: ((String) -> ())?
    
    private var coins: [CoinModel]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddCoinView: IAddCoinView {
    func sinkDataToView(coins: [CoinModel]) {
        self.coins = coins
    }
}

extension AddCoinView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.coins?.count ?? 0 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell()}
        guard let coins = self.coins else { return UICollectionViewCell()}
        cell.injectData(coin: coins[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
}

extension AddCoinView: UITextFieldDelegate {
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let previousText:NSString = textField.text! as NSString
        let updatedText = previousText.replacingCharacters(in: range, with: string)
        self.textFieldDataWorkflow?(updatedText)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textFieldDataWorkflow?("")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.textFieldDataWorkflow?("")
        return true
    }

}

extension AddCoinView: ISubscriber {
    func update(newData: [CoinModel]) {
        self.coins = newData
    }
}

private extension AddCoinView {
    func setupLayout() {
        self.setupSearchBar()
        self.setupCollectionView()
        self.setupCollectionLayout()
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
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/4.5, height: UIScreen.main.bounds.width/4.5)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear
        self.collectionView.showsHorizontalScrollIndicator = false
        
    }
    
    func setupCollectionLayout() {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.customSearchBar.bottomAnchor, constant: 20),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.collectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}
