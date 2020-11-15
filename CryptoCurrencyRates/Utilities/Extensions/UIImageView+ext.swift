//
//  UIImageView+ext.swift
//  CryptoCurrencyRates
//
//  Created by Roman Khodukin on 10/27/20.
//

import UIKit

extension UIImageView {
    func loadImage(by imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 50 * 1024 * 1024, diskPath: "images")
        let session = URLSession(configuration: configuration)
        
        let request = URLRequest(url: url)
                
        if let imageData = configuration.urlCache?.cachedResponse(for: request)?.data {
            self.image = UIImage(data: imageData)
        } else {
            let task = session.dataTask(with: request) { [unowned self] (data, response, error) in
                guard error == nil,
                      let data = data,
                      let response = response as? HTTPURLResponse, response.statusCode == 200
                else {
                    return
                }
                let cacheResponse = CachedURLResponse(response: response, data: data)
                configuration.urlCache?.storeCachedResponse(cacheResponse, for: request)
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
                
            }
            DispatchQueue.global(qos: .utility).async {
                task.resume()
            }
        }
    }
}
