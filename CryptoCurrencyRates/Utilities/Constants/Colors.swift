//
//  Colors.swift
//  CryptoCurrencyRates
//
//  Created by Roman Khodukin on 10/27/20.
//

import UIKit

extension Constants {
    enum Colors {
        static let greenColor = UIColor(hex: "#58B522")
        static let redColor = UIColor(hex: "#C7410E")
        static let orderCryptoButtonColor = UIColor(hex: "#8E8E93", alpha: 0.16)
        
        static var backgroundColor: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    // Return one of two colors depending on light or dark mode
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#000000") :
                        UIColor(hex: "#FFFFFF")
                }
            } else {
                // Same old color used for iOS 12 and earlier
                return UIColor(hex: "#FFFFFF")
            }
        }
        
        static var navBarColor: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#191C21") :
                        UIColor(hex: "#FFFFFF")
                }
            } else {
                return UIColor(hex: "#FFFFFF")
            }
        }
        
        static var labelColor: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#FFFFFF") :
                        UIColor(hex: "#000000")
                }
            } else {
                return UIColor(hex: "#FFFFFF")
            }
        }
        
        static var labelColorWithAlpha: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#FFFFFF", alpha: 0.5) :
                        UIColor(hex: "#000000", alpha: 0.5)
                }
            } else {
                return UIColor(hex: "#FFFFFF", alpha: 0.5)
            }
        }
        
        static var currencyRankViewColor: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#FFFFFF", alpha: 0.2) :
                        UIColor(hex: "#000000", alpha: 0.2)
                }
            } else {
                return UIColor(hex: "#FFFFFF", alpha: 0.2)
            }
        }
        
        static var grayColor: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#9B9EAD") :
                        UIColor(hex: "#6F7178")
                }
            } else {
                return UIColor(hex: "#6F7178")
            }
        }
    }
}
