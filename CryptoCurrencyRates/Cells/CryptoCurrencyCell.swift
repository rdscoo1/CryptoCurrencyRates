//
//  CryptoCurrencyCell.swift
//  CryptoCurrencyRates
//
//  Created by Roman Khodukin on 10/27/20.
//

import UIKit

class CryptoCurrencyCell: UITableViewCell {
    
    static let reuseId = String(describing: self)
    
    // MARK: - Private Properties
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = Constants.Colors.labelColor
        return label
    }()
    
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = Constants.Colors.grayColor
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = Constants.Colors.labelColor
        return label
    }()
    
    private lazy var priceChangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let currencyRankNumberView = CurrencyRankView()
    private let priceChangeArrow = UIImageView()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(currencyRankNumberView)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(priceChangeLabel)
        contentView.addSubview(priceChangeArrow)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with model: CurrencyModel) {
        iconImageView.loadImage(by: model.image)
        nameLabel.text = model.name
        currencyRankNumberView.setRank(number: model.marketCapRank)
        symbolLabel.text = model.symbol.uppercased()
        priceLabel.text = "$\(model.currentPrice)"
        var priceChange = String(format: "%.2f", model.priceChangePercentage24H ?? 0)
        
        if model.priceChangePercentage24H ?? 0 >= 0 {
            priceChangeLabel.textColor = Constants.Colors.greenColor
            priceChangeArrow.image = .rectangleArrowUp
            priceChangeArrow.tintColor = Constants.Colors.greenColor
        } else {
            priceChange = String(priceChange.dropFirst())
            priceChangeArrow.image = .rectangleArrowDown
            priceChangeArrow.tintColor = Constants.Colors.redColor
            priceChangeLabel.textColor = Constants.Colors.redColor
        }
        priceChangeLabel.text = "\(priceChange) %"
    }
    
    // MARK: - Private Methods
    
    private func configureConstraints() {
        currencyRankNumberView.translatesAutoresizingMaskIntoConstraints = false
        priceChangeArrow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            priceLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            priceChangeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            priceChangeLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            
            priceChangeArrow.centerYAnchor.constraint(equalTo: priceChangeLabel.centerYAnchor),
            priceChangeArrow.trailingAnchor.constraint(equalTo: priceChangeLabel.leadingAnchor, constant: -4),
            priceChangeArrow.heightAnchor.constraint(equalToConstant: 6),
            priceChangeArrow.widthAnchor.constraint(equalToConstant: 10),
            
            nameLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor, constant: -12),
            
            currencyRankNumberView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            currencyRankNumberView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            currencyRankNumberView.heightAnchor.constraint(equalToConstant: 18),
            currencyRankNumberView.widthAnchor.constraint(equalToConstant: 18),
            
            symbolLabel.centerYAnchor.constraint(equalTo: currencyRankNumberView.centerYAnchor),
            symbolLabel.leadingAnchor.constraint(equalTo: currencyRankNumberView.trailingAnchor, constant: 4),
            symbolLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
}
