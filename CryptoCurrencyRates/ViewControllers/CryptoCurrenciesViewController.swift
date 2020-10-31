//
//  CryptoCurrenciesViewController.swift
//  CryptoCurrencyRates
//
//  Created by Roman Khodukin on 10/27/20.
//

import UIKit

class CryptoCurrenciesViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CryptoCurrencyCell.self, forCellReuseIdentifier: CryptoCurrencyCell.reuseId)
        tableView.register(CryptoCurrenciesHeaderView.self, forHeaderFooterViewReuseIdentifier: CryptoCurrenciesHeaderView.reuseId)
        tableView.rowHeight = 80
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.sectionHeaderHeight = 48
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .prominent
//        searchBar.delegate = self
        return searchBar
    }()
    
    private let customActivityIndicator = CustomActivityIndicator(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
    
    private let networkService = NetworkService()
    
    // MARK: - Private variables
    
    private var filterCurrencies: [Currency] = []
    private var currencies: [Currency] = []
    private var page: Int = 2
    private var isLoading = false
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.backgroundColor
        
        title = "Currencies List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        customActivityIndicator.startAnimating()
        tableView.alpha = 0.0
        view.addSubview(tableView)
        view.addSubview(customActivityIndicator)
        
        configureConstraints()
        
        requestCurrencies()
    }
    
    // MARK: - Private Methods
    
    private func requestCurrencies() {
        networkService.getAllCoins(page: page - 1) { [weak self] currencies in
            self?.filterCurrencies = currencies
            self?.currencies = currencies
            self?.customActivityIndicator.alpha = 0.0
            self?.customActivityIndicator.stopAnimating()
            UIView.animate(withDuration: 0.3) {
                self?.tableView.alpha = 1.0
            }
            self?.tableView.reloadData()
        }
    }
    
    private func configureConstraints() {
        customActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customActivityIndicator.heightAnchor.constraint(equalToConstant: 64),
            customActivityIndicator.widthAnchor.constraint(equalToConstant: 64),
            customActivityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            customActivityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource

extension CryptoCurrenciesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoCurrencyCell.reuseId, for: indexPath) as? CryptoCurrencyCell else {
            return UITableViewCell()
        }
        
        let currency = filterCurrencies[indexPath.row]
        
        cell.configure(with: currency)
        
        return cell
    }
}

extension CryptoCurrenciesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard
            let maxRow = indexPaths.map({ $0.row }).max()
        else { return }
        
        let previousQuntity = currencies.count
        
        if maxRow > previousQuntity - 10,
           isLoading == false {
            
            isLoading = true
            
            networkService.getAllCoins(page: page) { [weak self] items in
                guard
                    let self = self,
                    items.count > 0
                else { return }
                
                let oldIndex = self.currencies.count
                self.page += 1
                
                var indexPathes: [IndexPath] = []
                self.filterCurrencies.append(contentsOf: items)
                self.currencies.append(contentsOf: items)
                for i in oldIndex..<(self.currencies.count) {
                    indexPathes.append(IndexPath(row: i, section: 0))
                }
                
                self.tableView.insertRows(at: indexPathes, with: .automatic)
                
                self.isLoading = false
            }
        }
    }
}

extension CryptoCurrenciesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: CryptoCurrenciesHeaderView.reuseId)
                as? CryptoCurrenciesHeaderView
        else {
            return nil
        }
        
        headerView.delegate = self
        
        return headerView
    }
}

// MARK: - UISearchBarDelegate

extension CryptoCurrenciesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            filterCurrencies = currencies.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        } else {
            filterCurrencies = currencies
        }
        tableView.reloadData()
    }
}

// MARK: - CryptoCurrenciesHeaderViewDelegate

extension CryptoCurrenciesViewController: CryptoCurrenciesHeaderViewDelegate {
    func orderButtonTapped() {
        present(getOrderActionSheet(handler: { result in
            switch result.title {
            case Constants.OrderCryptoCurrencyText.marketCap.rawValue:
                self.filterCurrencies = self.filterCurrencies.sorted { $0.marketCap > $1.marketCap }
                self.tableView.reloadData()
                print("\(Constants.OrderCryptoCurrencyText.marketCap.rawValue)")
                self.dismiss(animated: true)
            case Constants.OrderCryptoCurrencyText.volume.rawValue:
                self.filterCurrencies = self.filterCurrencies.sorted { $0.totalVolume > $1.totalVolume }
                self.tableView.reloadData()
                print("\(Constants.OrderCryptoCurrencyText.volume.rawValue)")
                self.dismiss(animated: true)
            case Constants.OrderCryptoCurrencyText.price.rawValue:
                self.filterCurrencies = self.filterCurrencies.sorted { $0.currentPrice > $1.currentPrice }
                self.tableView.reloadData()
                print("\(Constants.OrderCryptoCurrencyText.price.rawValue)")
                self.dismiss(animated: true)
            case Constants.OrderCryptoCurrencyText.name.rawValue:
                self.filterCurrencies = self.filterCurrencies.sorted { $1.name > $0.name }
                self.tableView.reloadData()
                print("\(Constants.OrderCryptoCurrencyText.name.rawValue)")
                self.dismiss(animated: true)
            case Constants.OrderCryptoCurrencyText.percentChange.rawValue:
                self.filterCurrencies = self.filterCurrencies.sorted { $0.priceChangePercentage24H ?? 0 > $1.priceChangePercentage24H ?? 0 }
                self.tableView.reloadData()
                print("\(Constants.OrderCryptoCurrencyText.percentChange.rawValue)")
                self.dismiss(animated: true)
            case Constants.OrderCryptoCurrencyText.rank.rawValue:
                self.filterCurrencies = self.filterCurrencies.sorted { $0.marketCapRank < $1.marketCapRank }
                self.tableView.reloadData()
                print("\(Constants.OrderCryptoCurrencyText.rank.rawValue)")
                self.dismiss(animated: true)
            case .none:
                print("nothing")
            case .some(_):
                print("some")
            }
        }), animated: true)
    }
}
