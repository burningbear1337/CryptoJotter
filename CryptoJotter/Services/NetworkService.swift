//
//  DataLoadManager.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 03.06.2022.
//

import Foundation

protocol INetworkService: AnyObject {
    func fetchCoinsList(urlsString: String, completion: @escaping (Result<[CoinModel],Error>)->())
    func fetchCoinData(urlsString: String?, completion: @escaping (Result<CoinDetailsModel,Error>)->())
}

final class NetworkService: INetworkService {
    
    func fetchCoinsList(urlsString: String, completion: @escaping (Result<[CoinModel], Error>) -> ()){
        
        guard let url = URL(string: urlsString) else { return }
        
        URLSession.shared.request(url: url, expecting: [CoinModel].self) { (result: Result<[CoinModel], Error>) in
            switch result {
            case .success(let coins):
                completion(.success(coins))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchCoinData(urlsString: String?, completion: @escaping (Result<CoinDetailsModel, Error>) -> ()) {
        
        guard let url = urlsString else { return }
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.request(url: url, expecting: CoinDetailsModel.self) { (result: Result<CoinDetailsModel, Error>) in
            switch result {
            case .success(let coin):
                completion(.success(coin))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension URLSession {
    func request<T: Codable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>)->()) {
        guard let url = url else {
            let error = NSError(domain: "Wrong url", code: 1, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        let task = dataTask(with: url) { data, _, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    let error = NSError(domain: "Wrong data", code: 3, userInfo: nil)
                    completion(.failure(error))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
}
