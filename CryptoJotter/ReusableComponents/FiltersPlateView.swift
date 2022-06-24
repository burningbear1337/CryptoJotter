//
//  FiltersPlateView.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 23.06.2022.
//

import UIKit

protocol IFiltersPlateView: AnyObject {
    func filterByRank() -> Bool
    func filterByPrice() -> Bool
    func filterByHoldings() -> Bool
    func reloadCoinsList()
}

final class FiltersPlateView: UIView {
    
    enum Constants {
        static let defaultPadding: CGFloat = 8
    }
    
    weak var filtersPlateViewDelegate: IFiltersPlateView?
    
    private lazy var filterByRankButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Rank ▼", for: .normal)
        button.titleLabel?.font = AppFont.semibold15.font
        button.setTitleColor(UIColor.theme.greenColor, for: .normal)
        button.addTarget(self, action: #selector(sortByRankTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var filterByHoldingsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Holdings", for: .normal)
        button.titleLabel?.font = AppFont.semibold15.font
        button.setTitleColor(UIColor.theme.greenColor, for: .normal)
        button.addTarget(self, action: #selector(sortByHoldingsTapped), for: .touchUpInside)
        return button
    }()

    
    private lazy var filterByPriceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Price", for: .normal)
        button.titleLabel?.font = AppFont.semibold15.font
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
    
    private var showHoldings: Bool?
    
    init(showHoldings: Bool) {
        self.showHoldings = showHoldings
        super.init(frame: .zero)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension FiltersPlateView {
    func setupLayout() {
        self.addSubview(self.filterByRankButton)
        NSLayoutConstraint.activate([
            self.filterByRankButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.filterByRankButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.filterByRankButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        guard let showHoldings = self.showHoldings else { return }
        if showHoldings {
            self.addSubview(self.filterByHoldingsButton)
            NSLayoutConstraint.activate([
                self.filterByHoldingsButton.leadingAnchor.constraint(equalTo: self.centerXAnchor),
                self.filterByHoldingsButton.centerYAnchor.constraint(equalTo: self.filterByRankButton.centerYAnchor)
            ])
        }
        
        self.addSubview(self.filterByPriceButton)
        NSLayoutConstraint.activate([
            self.filterByPriceButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.filterByPriceButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.filterByPriceButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        guard let showHoldings = self.showHoldings else { return }
        if !showHoldings {
            self.addSubview(self.reloadDataButton)
            NSLayoutConstraint.activate([
                self.reloadDataButton.topAnchor.constraint(equalTo: self.topAnchor),
                self.reloadDataButton.trailingAnchor.constraint(equalTo: self.filterByPriceButton.leadingAnchor, constant: -Constants.defaultPadding),
                self.reloadDataButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                self.reloadDataButton.heightAnchor.constraint(equalToConstant: 24),
                self.reloadDataButton.widthAnchor.constraint(equalToConstant: 24),
            ])
        }

    }
    
    @objc func sortByRankTapped() {
        self.filterByRankButton.alpha = 0.1
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.filterByRankButton.alpha = 1
        }

        self.filtersPlateViewDelegate?.filterByRank()  == true ?
        self.filterByRankButton.setTitle("Rank ▲", for: .normal) :
        self.filterByRankButton.setTitle("Rank ▼", for: .normal)
        self.filterByPriceButton.setTitle("Price", for: .normal)
        self.filterByHoldingsButton.setTitle("Holdings", for: .normal)
    }
    
    @objc func sortByPriceTapped() {
        self.filterByPriceButton.alpha = 0.1
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.filterByPriceButton.alpha = 1
        }
        
        self.filtersPlateViewDelegate?.filterByPrice() == true ?
        self.filterByPriceButton.setTitle("▲ Price", for: .normal) :
        self.filterByPriceButton.setTitle("▼ Price", for: .normal)
        self.filterByRankButton.setTitle("Rank", for: .normal)
        self.filterByHoldingsButton.setTitle("Holdings", for: .normal)
    }
    
    @objc func reloadDataTapped() {
        UIView.animate(withDuration: 2.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3) {
            self.reloadDataButton.transform = CGAffineTransform(rotationAngle: .pi)
            self.reloadDataButton.transform = .identity
        }
        self.filtersPlateViewDelegate?.reloadCoinsList()
        self.filterByRankButton.setTitle("Rank ▼", for: .normal)
        self.filterByPriceButton.setTitle("Price", for: .normal)
        self.filterByHoldingsButton.setTitle("Holdings", for: .normal)
    }
    
    @objc func sortByHoldingsTapped() {
        self.filterByHoldingsButton.alpha = 0.1
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.filterByHoldingsButton.alpha = 1
        }

        self.filtersPlateViewDelegate?.filterByHoldings() == true ?
        self.filterByHoldingsButton.setTitle("Holdings ▲", for: .normal) :
        self.filterByHoldingsButton.setTitle("Holdings ▼", for: .normal)
        self.filterByPriceButton.setTitle("Price", for: .normal)
        self.filterByRankButton.setTitle("Rank", for: .normal)
    }
}
