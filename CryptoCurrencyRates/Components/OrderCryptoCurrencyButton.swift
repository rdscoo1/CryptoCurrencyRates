//
//  OrderCryptoCurrencyButton.swift
//  CryptoCurrencyRates
//
//  Created by Roman Khodukin on 10/27/20.
//

import UIKit

protocol OrderCryptoCurrencyButtonDelegate: AnyObject {
    func didTapOrderCryptoButton()
}

class OrderCryptoCurrencyButton: UIView {
    
    // MARK: - Private Properties
    
    private lazy var sortLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.labelColor
        label.text = Constants.OrderCryptoCurrencyText.marketCap.rawValue
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private lazy var upArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .rectangleArrowUp
        imageView.tintColor = Constants.Colors.labelColor
        return imageView
    }()
    
    private lazy var downArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .rectangleArrowDown
        imageView.tintColor = Constants.Colors.labelColorWithAlpha
        return imageView
    }()
    
    // MARK: - Public Properties
    
    weak var delegate: OrderCryptoCurrencyButtonDelegate?
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
                
        setupView()
        
        addSubview(sortLabel)
        addSubview(upArrow)
        addSubview(downArrow)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setSordLabel(_ text: String) {
        sortLabel.text = text
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        isUserInteractionEnabled = true
        layer.cornerRadius = 16
        backgroundColor = Constants.Colors.orderCryptoButtonColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(sortViewTapped(_:)))
        addGestureRecognizer(tap)
    }
    
    private func configureConstraints() {        
        NSLayoutConstraint.activate([
            sortLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            sortLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sortLabel.trailingAnchor.constraint(lessThanOrEqualTo: upArrow.leadingAnchor, constant: 12),
            
            upArrow.heightAnchor.constraint(equalToConstant: 6),
            upArrow.widthAnchor.constraint(equalToConstant: 10),
            upArrow.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -5),
            upArrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            downArrow.heightAnchor.constraint(equalToConstant: 6),
            downArrow.widthAnchor.constraint(equalToConstant: 10),
            downArrow.topAnchor.constraint(equalTo: upArrow.bottomAnchor, constant: 5),
            downArrow.trailingAnchor.constraint(equalTo: upArrow.trailingAnchor)
        ])
    }
    
    @objc private func sortViewTapped(_: UITapGestureRecognizer) {
        delegate?.didTapOrderCryptoButton()
        alpha = 0.4
        UIView.animate(withDuration: 0.4, delay: 0.1, options: .curveEaseOut, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
}
