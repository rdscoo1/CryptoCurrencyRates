//
//  UIViewController+ext.swift
//  CryptoCurrencyRates
//
//  Created by Roman Khodukin on 10/28/20.
//

import UIKit

extension UIViewController {
    func presentErrorAlert(tryAgainHandler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let haptic: HapticFeedback = .error
        let alertVC = UIAlertController(title: "Ошибка", message: "Проверьте ваше подключение", preferredStyle: .alert)
        let tryAgainAction = UIAlertAction(title: "Попробовать еще раз", style: .default, handler: tryAgainHandler)
        alertVC.addAction(tryAgainAction)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        haptic.impact()
        return alertVC
    }
    
    func getOrderActionSheet(handler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let haptic: HapticFeedback = .success
        let alertController = UIAlertController(title: "Order by", message: nil, preferredStyle: .actionSheet)
        
        let marketCap = UIAlertAction(title: Constants.OrderCryptoCurrencyText.marketCap.rawValue, style: .default, handler: handler)
        let volume = UIAlertAction(title: Constants.OrderCryptoCurrencyText.volume.rawValue, style: .default, handler: handler)
        let price = UIAlertAction(title: Constants.OrderCryptoCurrencyText.price.rawValue, style: .default, handler: handler)
        let name = UIAlertAction(title:Constants.OrderCryptoCurrencyText.name.rawValue, style: .default, handler: handler)
        let percentChange = UIAlertAction(title: Constants.OrderCryptoCurrencyText.percentChange.rawValue, style: .default, handler: handler)
        let rank = UIAlertAction(title: Constants.OrderCryptoCurrencyText.rank.rawValue, style: .default, handler: handler)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(marketCap)
        alertController.addAction(volume)
        alertController.addAction(price)
        alertController.addAction(name)
        alertController.addAction(percentChange)
        alertController.addAction(rank)
        alertController.addAction(actionCancel)
        
        alertController.pruneNegativeWidthConstraints()
        haptic.impact()
        return alertController
    }
}
