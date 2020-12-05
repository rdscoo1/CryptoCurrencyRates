//
//  NetworkService.swift
//  CryptoCurrencyRates
//
//  Created by Roman Khodukin on 10/27/20.
//

import Foundation

enum ApiPaths: String {
    case markets = "/coins/markets"
}

class NetworkService {
    
    typealias results<T> = (Result<[T], RequestError>) -> Void
    
    // MARK: - Public Methods
    
    func getAllCoins(page: Int, completion: @escaping (Result<[CurrencyModel], Error>) -> Void) {
        let params: [String: String] = [
            "vs_currency": "usd",
            "order": "market_cap_desc",
            "per_page": "100",
            "page": "\(page)",
            "sparkline": "false",
            "price_change_percentage": "24h"
        ]
        
        makeRequest(CurrencyModel.self,
                    httpMethod: .get,
                    path: .markets,
                    parameters: params) { response in
            switch response {
            case .success(let items):
                completion(.success(items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func makeRequest<T: Decodable>(_ model: T.Type,
                                           httpMethod: HTTPMethod,
                                           path: ApiPaths,
                                           parameters: [String: String]? = nil,
                                           completion: @escaping results<T>) {
        let request = buildRequest(path: path.rawValue, method: httpMethod, parameters: parameters)
        NetworkLogger.log(request: request)
        
        let configuration = createConfiguration()
        let session = URLSession(configuration: configuration)
        
        session.dataTask(with: request) { (data, response, error) in
//            print("↩️ ↩️ ↩️ Data request: \(String(describing: String(data: data ?? Data(), encoding: .utf8)))")
            guard error == nil else {
                print("❌ ❌ ❌ Error request: \(String(describing: error))")
                completion(.failure(.client))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let items = try decoder.decode([T].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(items))
                }
            } catch {
                print("❌ \(RequestError.unableToDecode.reason) ❌\n\(error)")
            }
        }.resume()
    }
    
    private func createConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForResource = 60
        configuration.httpAdditionalHeaders = [
            "Content-type": "application/json",
            "Accept-Charset": "utf-8"
        ]
        
        return configuration
    }
    
    private func buildRequest(path: String,
                              method: HTTPMethod,
                              parameters: [String: String]? = nil) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constants.baseUrl
        components.path = "/api/v3/\(path)"
        
        if let parameters = parameters {
            components.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        
        var request = URLRequest(url: components.url!, timeoutInterval: 10.0)
        
        request.httpMethod = method.rawValue
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
            return .noRights
        case 500...:
            return .server
        default:
            return .unknown
        }
    }
}
