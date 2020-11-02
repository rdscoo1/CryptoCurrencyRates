//
//  CryptoCurrenciesHeaderView.swift
//  CryptoCurrencyRates
//
//  Created by Roman Khodukin on 10/28/20.
//

import UIKit

protocol CryptoCurrenciesHeaderViewDelegate: AnyObject {
    func orderButtonTapped()
}

class CryptoCurrenciesHeaderView: UITableViewHeaderFooterView {

    static let reuseId: String = String(describing: self)
    
    // MARK: - Private Properties
    
    private let orderCryptoCurrencyButton = OrderCryptoCurrencyButton()
    
    // MARK: - Public Properties
    
    weak var delegate: CryptoCurrenciesHeaderViewDelegate?
    
    // MARK: - Initializers
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        orderCryptoCurrencyButton.delegate = self
        
        contentView.backgroundColor = Constants.Colors.backgroundColor
        contentView.addSubview(orderCryptoCurrencyButton)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Properties
    
    func configureHeaderLabel(_ text: String) {
        orderCryptoCurrencyButton.setSordLabel(text)
    }
    
    // MARK: - Private Methods
    
    private func configureConstraints() {
        orderCryptoCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            orderCryptoCurrencyButton.heightAnchor.constraint(equalToConstant: 32),
            orderCryptoCurrencyButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            orderCryptoCurrencyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            orderCryptoCurrencyButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 16)
        ])
    }
}

extension CryptoCurrenciesHeaderView: OrderCryptoCurrencyButtonDelegate {
    func didTapOrderCryptoButton() {
        delegate?.orderButtonTapped()
    }
}
