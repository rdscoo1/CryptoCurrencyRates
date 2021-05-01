//
//  CustomNavigationBar.swift
//  CryptoCurrencyRates
//
//  Created by Roman Khodukin on 10/27/20.
//

import UIKit

class CustomNavigationBar: UIView {
    
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = Constants.Colors.labelColor
        return label
    }()
    
    private let orderCryptoButton = OrderCryptoCurrencyButton()
    
    // MARK: - Initializers
    
    init(title: String) {
        super.init(frame: .zero)
        
        backgroundColor = Constants.Colors.navBarColor
        
        titleLabel.text = title
        
        addSubview(titleLabel)
        addSubview(orderCryptoButton)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    
    
    // MARK: - Private Methods
    
    private func configureConstraints() {
        orderCryptoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            orderCryptoButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            orderCryptoButton.heightAnchor.constraint(equalToConstant: 36),
            orderCryptoButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            orderCryptoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}
