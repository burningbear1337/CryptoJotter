//
//  DataLoadManager.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 03.06.2022.
//

import Foundation

protocol INetworkManager: AnyObject {
    func fetchCoinsList<T:Codable>(urlsString: String, completion: @escaping (Result<[T],Error>)->())
    func fetchCoinData<T: Codable>(urlsString: String?, completion: @escaping (Result<T?,Error>)->())
}

final class NetworkManager {}

extension NetworkManager: INetworkManager {
    
    func fetchCoinsList<T>(urlsString: String, completion: @escaping (Result<[T], Error>) -> ()) where T : Decodable, T : Encodable {
        
        guard let url = URL(string: urlsString) else { return }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode([T].self, from: data)
                completion(.success(result))
            }
            catch let error {
                completion(.failure(error))
                print(error.localizedDescription)
            }
            
        }.resume()
    }
    
    func fetchCoinData<T>(urlsString: String?, completion: @escaping (Result<T?, Error>) -> ()) where T : Decodable, T : Encodable {
        
        guard let urlsString = urlsString else { return }
        
        guard let url = URL(string: urlsString) else { return }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            }
            catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
}
