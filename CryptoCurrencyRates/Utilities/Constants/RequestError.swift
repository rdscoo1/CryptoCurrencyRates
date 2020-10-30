//
//  RequestError.swift
//  CryptoCurrencyRates
//
//  Created by Roman Khodukin on 10/27/20.
//

import Foundation

enum RequestError: String, Error, LocalizedError {
    case norights = "❌ Нет прав доступа к содержимому ❌"
    case wrongSyntax = "❌ Неверный синтаксис запроса ❌"
    case server = "❌ Ошибка сервера ❌"
    case client = "❌ Ошибка клиента ❌"
    case noData = "❌ Нет данных ❌"
    case decoding = "❌ Декодирование не удалось. ❌"
    case unauthorized = "❌ Вы не авторизованы ❌"
    case unknown = "❌ Неизвестная ошибка ❌"
    
    var localizedDescription: String {
        return self.rawValue
    }
}
