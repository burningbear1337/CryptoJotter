//
//  AddCoinView.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 16.06.2022.
//

import UIKit

protocol IAddCoinView: AnyObject {
    
    var textFieldDataWorkflow: ((String) -> ())? { get set }
    var saveButtonTap:((CoinModel, Double)->())? { get set }
    var clickedOnCoin: ((CoinModel)->(String))? { get set }
}

final class AddCoinView: UIView, IAddCoinView {
    
    private enum Constants {
        static let cellID = "collectionCell"
        static let collectionViewHeight: CGFloat = 100
        
        static let searchBarPadding: CGFloat = 20
        static let searchBarHeight: CGFloat = 55
        static let defaultPadding: CGFloat = 20
        static let spacingForCoinData: CGFloat = 30
        static let imageFrame:CGFloat = 26
        static let coinImageLeadingPadding:CGFloat = 5
        static let textFieldWidth: CGFloat = 105
        static let buttonHeigh: CGFloat = 55
        
        static let currentPriceText = "Current Price:"
        static let coinHoldingsText = "Your holdings:"
        static let coinDepositText = "Your deposit:"
        static let defaultCoinDepositText = "$0.00"
        
        static let saveButtonTitleText = "Save"
        static let saveButtonUpdateTitleText = "UPDATED ✅"
    }
    
    private lazy var customSearchBar = CustomSearchBarView()
    private lazy var collectionView = UICollectionView()
    
    private lazy var currentPriceTitle: UILabel = {
        let label = UILabel()
        label.text = Constants.currentPriceText
        label.font = AppFont.semibold17.font
        label.textAlignment = .left
        label.textColor = UIColor.theme.accentColor
        label.layer.opacity = 0
        return label
    }()
    
    private lazy var currentPriceValue: UILabel = {
        let label = UILabel()
        label.font = AppFont.semibold17.font
        label.textAlignment = .right
        label.textColor = UIColor.theme.accentColor
        label.layer.opacity = 0
        return label
    }()
    
    private lazy var coinHoldingsTitle: UILabel = {
        let label = UILabel()
        label.text = Constants.coinHoldingsText
        label.font = AppFont.semibold17.font
        label.textAlignment = .left
        label.textColor = UIColor.theme.accentColor
        label.layer.opacity = 0
        return label
    }()
    
    private lazy var coinDepositTitle: UILabel = {
        let label = UILabel()
        label.text = Constants.coinDepositText
        label.font = AppFont.semibold17.font
        label.textAlignment = .left
        label.textColor = UIColor.theme.accentColor
        label.layer.opacity = 0
        return label
    }()
    
    private lazy var coinImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private lazy var coinsAmountTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.keyboardType = .decimalPad
        textField.textAlignment = .right
        textField.layer.backgroundColor = UIColor.clear.cgColor
        let emptyView = UIView(frame: .init(x: .zero, y: .zero, width: 0, height: .zero))
        textField.leftViewMode = .always
        textField.leftView = emptyView
        textField.rightViewMode = .always
        textField.rightView = emptyView
        textField.delegate = self
        return textField
    }()
    
    private lazy var coinDepositValue: UILabel = {
        let label = UILabel()
        label.font = AppFont.semibold17.font
        label.textAlignment = .right
        label.text = Constants.defaultCoinDepositText
        label.textColor = UIColor.theme.accentColor
        label.layer.opacity = 0
        return label
    }()
    
    private var holdings: Double?
    {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.coinDepositValue.text = "$" + (((self?.coin?.currentPrice ?? 0) * (self?.holdings ?? 0)).convertToStringWith2Decimals())
            }
        }
    }
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.theme.secondaryBackgroundColor?.cgColor
        button.setTitle(Constants.saveButtonTitleText, for: .normal)
        button.setTitleColor(UIColor.theme.greenColor, for: .normal)
        button.titleLabel?.font = AppFont.semibold17.font
        button.layer.borderColor = UIColor.theme.greenColor?.cgColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.opacity = 0
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var textFieldDataWorkflow: ((String) -> ())?
    var saveButtonTap:((CoinModel, Double)->())?
    var clickedOnCoin: ((CoinModel)->(String))?
    
    private var coin: CoinModel?
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

extension AddCoinView: ISubscriber {
    func update(newData: [CoinModel]) {
        self.coins = newData
    }
}

extension AddCoinView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.coins?.count ?? 0 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellID, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell()}
        guard let coin = self.coins?[indexPath.row] else { return UICollectionViewCell()}
        cell.injectData(coin: coin)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let coin = self.coins?[indexPath.row] else { return }
        DispatchQueue.main.async {
            self.coin = coin
            self.injectDataToInterface(coin: coin)
        }
    }
}

extension AddCoinView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case coinsAmountTextField:
            let previous:NSString = textField.text! as NSString
            let updated = previous.replacingCharacters(in: range, with: string)
            self.holdings = Double(updated)
        default:
            let previousText:NSString = textField.text! as NSString
            let updatedText = previousText.replacingCharacters(in: range, with: string)
            self.textFieldDataWorkflow?(updatedText)
            if updatedText == "" {
                self.opactityControl(value: 0)
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.textFieldDataWorkflow?("")
        self.opactityControl(value: 0)
        return true
    }
}

private extension AddCoinView {
    
    func injectDataToInterface(coin: CoinModel) {
        self.opactityControl(value: 1)
        self.currentPriceValue.text = "$\(self.coin?.currentPrice?.convertToStringWith2Decimals() ?? "0.00")"
        self.coinDepositValue.text = "$" + ((self.coin?.currentPrice ?? 0) * (Double(self.clickedOnCoin?(coin) ?? "") ?? 0.00)).convertToStringWith2Decimals()
        self.coinsAmountTextField.placeholder = self.clickedOnCoin?(coin)
        let coinImageService = CoinImageService(coin: coin)
        coinImageService.setCoinImage { image in
            DispatchQueue.main.async {
                self.coinImage.image = image
            }
        }
    }
    
    func setupLayout() {
        self.setupSearchBar()
        self.setupCollectionView()
        self.setupCollectionLayout()
        self.setupAddCoinInterface()
        self.setupSaveButton()
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
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/4.5, height: UIScreen.main.bounds.width/4.5)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: Constants.cellID)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear
        self.collectionView.showsHorizontalScrollIndicator = false
    }
    
    func setupCollectionLayout() {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.customSearchBar.bottomAnchor, constant: Constants.defaultPadding*0.4),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.collectionView.heightAnchor.constraint(equalToConstant: Constants.collectionViewHeight)
        ])
    }
        
    func setupAddCoinInterface() {
        self.addSubview(self.currentPriceTitle)
        self.currentPriceTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.currentPriceTitle.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: Constants.defaultPadding),
            self.currentPriceTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.defaultPadding)
        ])
        
        self.addSubview(self.currentPriceValue)
        self.currentPriceValue.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.currentPriceValue.centerYAnchor.constraint(equalTo: self.currentPriceTitle.centerYAnchor),
            self.currentPriceValue.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.defaultPadding )
        ])
        
        self.addSubview(self.coinHoldingsTitle)
        self.coinHoldingsTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.coinHoldingsTitle.topAnchor.constraint(equalTo: self.currentPriceTitle.bottomAnchor, constant: Constants.spacingForCoinData),
            self.coinHoldingsTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.defaultPadding),
        ])
        
        self.addSubview(self.coinImage)
        self.coinImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.coinImage.centerYAnchor.constraint(equalTo: self.coinHoldingsTitle.centerYAnchor),
            self.coinImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.defaultPadding),
            self.coinImage.heightAnchor.constraint(equalToConstant: Constants.imageFrame),
            self.coinImage.widthAnchor.constraint(equalToConstant: Constants.imageFrame),
        ])
        
        self.addSubview(self.coinsAmountTextField)
        self.coinsAmountTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.coinsAmountTextField.topAnchor.constraint(equalTo: self.currentPriceTitle.bottomAnchor, constant: Constants.spacingForCoinData),
            self.coinsAmountTextField.trailingAnchor.constraint(equalTo: self.coinImage.leadingAnchor,constant: -Constants.coinImageLeadingPadding),
            self.coinsAmountTextField.widthAnchor.constraint(equalToConstant: Constants.textFieldWidth)

        ])
        
        self.addSubview(self.coinDepositTitle)
        self.coinDepositTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.coinDepositTitle.topAnchor.constraint(equalTo: self.coinHoldingsTitle.bottomAnchor, constant: Constants.spacingForCoinData),
            self.coinDepositTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.defaultPadding),
        ])
        
        self.addSubview(self.coinDepositValue)
        self.coinDepositValue.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.coinDepositValue.centerYAnchor.constraint(equalTo: self.coinDepositTitle.centerYAnchor),
            self.coinDepositValue.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.defaultPadding )
        ])
    }
    
    func setupSaveButton() {
        self.saveButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.saveButton)
        NSLayoutConstraint.activate([
            self.saveButton.topAnchor.constraint(equalTo: self.coinDepositTitle.bottomAnchor, constant: Constants.defaultPadding),
            self.saveButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.saveButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeigh),
            self.saveButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.defaultPadding),
            self.saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.defaultPadding)
        ])
    }
    
    func opactityControl(value: Float ) {
        self.currentPriceTitle.layer.opacity = value
        self.currentPriceValue.layer.opacity = value
        self.coinHoldingsTitle.layer.opacity = value
        self.coinDepositTitle.layer.opacity = value
        self.coinDepositValue.layer.opacity = value
        self.coinsAmountTextField.layer.opacity = value
        self.saveButton.layer.opacity = value
        self.coinImage.layer.opacity = value
        self.coinsAmountTextField.attributedPlaceholder = NSAttributedString(
            string: "",
            attributes: [
                NSAttributedString.Key.font : AppFont.semibold17.font as Any,
                NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(CGFloat(value)),
            ]
        )
    }
    
    @objc func saveButtonTapped() {
        guard
            let coin = self.coin,
            let holdings = self.holdings else { return }
        self.saveButtonTap?(coin, holdings)
        self.injectDataToInterface(coin: coin)
        self.saveButton.setTitle(Constants.saveButtonUpdateTitleText, for: .normal)
        self.coinsAmountTextField.text = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.saveButton.setTitle(Constants.saveButtonTitleText, for: .normal)
        }
    }
}
