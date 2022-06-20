//
//  MainPublisher.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 15.06.2022.
//

import Foundation

protocol ISubscriber: AnyObject {
    func update(newData: [CoinModel])
}

protocol IPublisher: AnyObject {
    var newData: [CoinModel]? { get }
    var subscribers: [ISubscriber] { get set }
    
    func subscribe(_ subscriber: ISubscriber)
    func unsubscriber(_ subscriber: ISubscriber)
    
    func notify(_ newData: [CoinModel])
}

final class CoinsPublisherManager {
    var newData: [CoinModel]? {
        didSet {
            self.notify(self.newData ?? [])
        }
    }
    
    var subscribers = [ISubscriber]()
}

extension CoinsPublisherManager: IPublisher{
    
    func subscribe(_ subscriber: ISubscriber) {
        self.subscribers.append(subscriber)
    }
    
    func unsubscriber(_ subscriber: ISubscriber) {
        self.subscribers = self.subscribers.filter({$0 !== subscriber})
    }
    
    func notify(_ newData: [CoinModel]) {
        self.subscribers.forEach({ $0.update(newData: newData)})
    }
}
