//
//  CoinImageService.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 14.06.2022.
//

import Foundation
import UIKit

final class CoinImageService {
    
    private var coin: CoinModel
    private var filemanager = FileManagerService.shared
    private let folderName = "CoinJotter_images"
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.name
    }
    
    func setCoinImage(completion: @escaping (UIImage)->()) {
        if let savedImage = self.filemanager.fetchImage(imageName: self.imageName, folderName: self.folderName) {
            print("loaded image form File Manager")
            completion(savedImage)
        } else {
            self.fetchCoinImage { image in
                print("Downloading image for Internet")
                completion(image)
            }
        }
    }
    
    private func fetchCoinImage(completion: @escaping (UIImage)->()){
        guard let url = URL(string: self.coin.image) else { return }
        let request = URLRequest(url: url)
        URLSession.shared.downloadTask(with: request) { url, response, error in
            if let error = error {
                print("❌\(error.localizedDescription)")
            }
            
            guard let url = url else { return }
            
            let data = try? Data(contentsOf: url)
            
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            self.filemanager.saveImage(image: image, imageName: self.coin.name, folderName: self.folderName)
            completion(image)
        }.resume()
    }
}
