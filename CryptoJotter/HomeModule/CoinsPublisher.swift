//
//  MainPublisher.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 15.06.2022.
//

import Foundation

protocol IMainSubscriber: AnyObject {
    func update(newData: [CoinModel])
}

protocol IMainViewPublisher: AnyObject {
    var newData: [CoinModel]? { get }
    var subscribers: [IMainSubscriber] { get set }
    
    func subscribe(_ subscriber: IMainSubscriber)
    func unsubscriber(_ subscriber: IMainSubscriber)
    
    func notify(_ newData: [CoinModel])
}

final class CoinsPublisher {
    var newData: [CoinModel]? {
        didSet {
            self.notify(self.newData ?? [])
        }
    }
    
    var subscribers = [IMainSubscriber]()
}

extension CoinsPublisher: IMainViewPublisher{
    
    func subscribe(_ subscriber: IMainSubscriber) {
        self.subscribers.append(subscriber)
    }
    
    func unsubscriber(_ subscriber: IMainSubscriber) {
        self.subscribers = self.subscribers.filter({$0 !== subscriber})
    }
    
    func notify(_ newData: [CoinModel]) {
        self.subscribers.forEach({ $0.update(newData: newData)})
    }
}
