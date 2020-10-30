//
//  NetworkService.swift
//  CryptoCurrencyRates
//
//  Created by Roman Khodukin on 10/27/20.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

enum ApiPaths: String {
    case markets = "/coins/markets"
}

class NetworkService {

    // MARK: - Public Methods
    
    func getAllCoins(page: Int, completion: @escaping ([Currency]) -> Void) {
        let params: [String: String] = [
            "vs_currency": "usd",
            "order": "market_cap_desc",
            "per_page": "100",
            "page": "\(page)",
            "sparkline": "false",
            "price_change_percentage": "24h"
        ]
        
        makeRequest(Currency.self,
                    path: .markets,
                    httpMethod: .get,
                    parameters: params) { response in
            switch response {
            case .success(let items):
                completion(items)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func makeRequest<T: Decodable>(_ model: T.Type,
                                   path: ApiPaths,
                                   httpMethod: HTTPMethod,
                                   parameters: [String: String]? = nil,
                                   completion: @escaping (Result<[T], RequestError>) -> Void) {
        let urlString = Constants.baseUrl + path.rawValue
        
        guard let url = URL(string: urlString) else {
            return
        }
                        
        let request = createRequest(url: url, method: httpMethod, parameters: parameters)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            print("❌ ❌ ❌ Error request: \(String(describing: error))")
//            print("↩️ ↩️ ↩️ Data request: \(String(describing: String(data: data ?? Data(), encoding: .utf8)))")
            
            guard
                error == nil
            else {
                completion(.failure(.client))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
                        
            do {
                let items = try JSONDecoder().decode([T].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(items))
                }
            } catch {
                print("❌ \(RequestError.decoding.localizedDescription) ❌\n\(error)")
            }
        }
        
        DispatchQueue.global(qos: .utility).async {
            task.resume()
        }
    }
    
    private func createRequest(url: URL,
                               method: HTTPMethod,
                               parameters: [String: String]? = nil) -> URLRequest {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return URLRequest(url: url)
        }
        components.scheme = "https"
        
        if let parameters = parameters {
            components.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }
        
        var request = URLRequest(url: components.url!)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        request.httpMethod = method.rawValue
        request.timeoutInterval = 15
        return request
    }
    
    private func checkStatusCode(_ code: Int) -> RequestError? {
        print("Status code: \(code)")
        switch code {
        case 200..<300:
            return nil
        case 400:
            return .wrongSyntax
        case 401:
            return .unauthorized
        case 403:
            return .norights
        case 500...:
            return .server
        default:
            return .unknown
        }
    }
}
