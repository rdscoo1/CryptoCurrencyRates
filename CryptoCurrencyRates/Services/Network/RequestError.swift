//
//  RequestError.swift
//  CryptoCurrencyRates
//
//  Created by Roman Khodukin on 10/27/20.
//

import Foundation

enum RequestError: String, Error, LocalizedError {
    case unauthorized = "❌ Вы не авторизованы ❌"
    case noRights = "❌ Нет прав доступа к содержимому ❌"
    case wrongSyntax = "❌ Неверный синтаксис запроса ❌"
    case server = "❌ Ошибка сервера ❌"
    case client = "❌ Ошибка клиента ❌"
    case noData = "❌ Данные не пришли ❌"
    case unableToDecode = "❌ Декодирование не удалось ❌"
    case unknown = "❌ Неизвестная ошибка ❌"
    
    var localizedDescription: String {
        return self.rawValue
    }
}
