//
//  NetworkLogger.swift
//  CryptoCurrencyRates
//
//  Created by Roman Khodukin on 12/5/20.
//

import Foundation

class NetworkLogger {
    static func log(request: URLRequest) {
        
        print("\n📤 - - - - - - - - - - OUTGOING - - - - - - - - - - 📤\n")
        defer { print("\n  - - - - - - - - - - - END - - - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
                        HOST: \(host)
                        \(method) \(path)?\(query)\n
                        URL: \(urlAsString)
                        """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        print(logOutput)
    }
}
