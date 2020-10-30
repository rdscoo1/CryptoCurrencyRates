//
//  Constants.swift
//  CryptoCurrencyRates
//
//  Created by Roman Khodukin on 10/27/20.
//

import UIKit

struct Constants {
    static let baseUrl = "api.coingecko.com/api/v3"
    
    enum OrderCryptoCurrencyText: String {
        case marketCap = "Market Cap"
        case volume = "Volume"
        case price = "Price"
        case name = "Name"
        case percentChange = "% Change"
        case rank = "Rank"
    }
}
