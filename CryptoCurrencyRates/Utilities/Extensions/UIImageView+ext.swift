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
        
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        
        if let imageDate = cache.cachedResponse(for: request)?.data {
            self.image = UIImage(data: imageDate)
        } else {
            let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
                guard error == nil,
                      let data = data,
                      let response = response as? HTTPURLResponse, response.statusCode == 200
                else {
                    return
                }
                let cacheResponse = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cacheResponse, for: request)
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
