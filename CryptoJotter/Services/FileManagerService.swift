//
//  FileManagerService.swift
//  CryptoJotter
//
//  Created by Miroslav Berezovsky on 14.06.2022.
//

import Foundation
import UIKit

final class FileManagerService {
    
    static let shared = FileManagerService()
    
    private init() { }
    
    func fetchImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = urlForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        self.createFolder(folderName: folderName)
        guard
            let data = image.pngData(),
            let url = urlForImage(imageName: imageName, folderName: folderName) else {
            return
        }
        
        do {
            try data.write(to: url)
        }
        catch {
            print("Can't save image \(imageName) - \(error.localizedDescription)")
        }
    }
}

private extension FileManagerService {
    
    func urlForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return url.appendingPathComponent(folderName)
    }
    
    func urlForImage(imageName: String, folderName: String) -> URL? {
        guard let url = self.urlForFolder(folderName: folderName) else { return nil}
        return url.appendingPathComponent(imageName+".png")
    }
    
    func createFolder(folderName: String) {
        guard let url = urlForFolder(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            }
            catch {
                print("Error creating folder with name: \(folderName)")
            }
        }
    }
}
