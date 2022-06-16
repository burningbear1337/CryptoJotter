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
    func addCoinToPortfolio(coinName: String, amount: Int)
    func deleteCoinFromPortfolio(coin: CoinItem)
    func updateCoinInPortfolio(coin: CoinItem, amount: Int)
}

final class CoreDataUtility: ICoreDataUtility {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchPortfolio(completion: @escaping ([CoinItem]) -> ()) {
        let fetchRequest = CoinItem.fetchRequest()
        let sort = NSSortDescriptor(key: "amout", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        guard let coinItems = try? context.fetch(fetchRequest) else { return }
        completion(coinItems)
    }
    
    func addCoinToPortfolio(coinName: String, amount: Int) {
        let coin = CoinItem(context: self.context)
        coin.name = coinName
        coin.amount = Int64(amount)
        try? self.context.save()
    }
    
    func deleteCoinFromPortfolio(coin: CoinItem) {
        self.context.delete(coin)
        try? self.context.save()
    }
    
    func updateCoinInPortfolio(coin: CoinItem, amount: Int) {
        coin.amount = Int64(amount)
        try? self.context.save()
    }
}

