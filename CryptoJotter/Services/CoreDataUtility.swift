//
//  CoreDataUtility.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 15.06.2022.
//

import Foundation
import UIKit

protocol ICoreDataUtility: AnyObject {
    
    func fetchPortfolio(completion: @escaping ([CoinItem])->())
    func addCoinToPortfolio(coin: CoinModel, amount: Double)
    func deleteCoinFromPortfolio(coin: CoinItem)
    func updateCoinInPortfolio(coinItem: CoinItem, amount: Double)
}

final class CoreDataUtility: ICoreDataUtility {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchPortfolio(completion: @escaping ([CoinItem]) -> ()) {
        let fetchRequest = CoinItem.fetchRequest()
        let sort = NSSortDescriptor(key: "amount", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        guard let coinItems = try? context.fetch(fetchRequest) else { return }
        completion(coinItems)
    }
    
    func addCoinToPortfolio(coin: CoinModel, amount: Double) {
        let newCoin = CoinItem(context: self.context)
        newCoin.symbol = coin.symbol?.lowercased()
        newCoin.name = coin.name?.lowercased()
        newCoin.currentPrice = coin.currentPrice ?? 0.00
        newCoin.image = coin.image
        newCoin.priceChange24H = coin.priceChangePercentage24H ?? 0.00
        newCoin.rank = coin.marketCapRank ?? 0
        newCoin.amount = amount
        try? self.context.save()
    }
    
    func deleteCoinFromPortfolio(coin: CoinItem) {
        self.context.delete(coin)
        try? self.context.save()
    }
    
    func updateCoinInPortfolio(coinItem: CoinItem, amount: Double) {
        coinItem.amount = amount
        try? self.context.save()
    }
}

