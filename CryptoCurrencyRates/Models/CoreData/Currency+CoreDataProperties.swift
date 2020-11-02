//
//  Currency+CoreDataProperties.swift
//  CryptoCurrencyRates
//
//  Created by Roman Khodukin on 11/1/20.
//
//

import Foundation
import CoreData


extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
    @NSManaged public var currentPrice: Double
    @NSManaged public var priceChangePercentage24H: Double
    @NSManaged public var marketCapRank: Int32
    @NSManaged public var id: String?

}
