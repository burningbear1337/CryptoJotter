//
//  DataLoadManager.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 03.06.2022.
//

import Foundation

protocol INetworkManager: AnyObject {
    func fetchArrayOfData<T:Codable>(urlsString: String, completion: @escaping (Result<[T],Error>)->())
    func fetchDataElement<T: Codable>(urlsString: String, completion: @escaping (Result<T?,Error>)->())
}

final class NetworkManager {
    
}

extension NetworkManager: INetworkManager {
    
    func fetchArrayOfData<T>(urlsString: String, completion: @escaping (Result<[T], Error>) -> ()) where T : Decodable, T : Encodable {
        
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
    
    func fetchDataElement<T>(urlsString: String, completion: @escaping (Result<T?, Error>) -> ()) where T : Decodable, T : Encodable {
        
        guard let url = URL(string: urlsString) else { return }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.downloadTask(with: request) { url, response, error in
            
            if let error = error {
                completion(.failure(error))
            }
            
            guard let url = url else { return }
            
            if let data = try? Data(contentsOf: url) {
                completion(.success(data as? T))
            }
        }
    }
}
