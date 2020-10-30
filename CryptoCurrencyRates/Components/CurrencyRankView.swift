//
//  CurrencyRankView.swift
//  CryptoCurrencyRates
//
//  Created by Roman Khodukin on 10/28/20.
//

import UIKit

class CurrencyRankView: UIView {
    
    // MARK: - Private Properties
    
    private lazy var rankNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = Constants.Colors.labelColor
        return label
    }()
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        
        addSubview(rankNumberLabel)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setRank(number: Int) {
        rankNumberLabel.text = "\(number)"
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        backgroundColor = Constants.Colors.currencyRankViewColor
        layer.cornerRadius = 4
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            rankNumberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            rankNumberLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
