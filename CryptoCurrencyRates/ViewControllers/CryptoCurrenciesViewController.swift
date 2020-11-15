//
//  CryptoCurrenciesViewController.swift
//  CryptoCurrencyRates
//
//  Created by Roman Khodukin on 10/27/20.
//

import UIKit
import CoreData

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
    
    private lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlbumItem")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataService.shared.context, sectionNameKeyPath: #keyPath(Currency.name), cacheName: nil)
        return frc
    }()
    
    // MARK: - Private variables
    
    private var currenciesObjects: [NSManagedObject]? = []
    private var filterCurrencies: [CurrencyModel] = []
    private var currencies: [CurrencyModel] = []
    private var page: Int = 2
    private var isLoading = false
    private var orderByString = Constants.OrderCryptoCurrencyText.marketCap.rawValue
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.backgroundColor
        
        customActivityIndicator.startAnimating()
        tableView.alpha = 0.0
        
        setupViews()
        
        loadFromCoreData()
        requestCurrencies()
    }
    
    // MARK: - Private Methods
    
    private func requestCurrencies() {
        networkService.getAllCoins(page: page - 1) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let currencies):
                self.filterCurrencies = currencies
                self.currencies = currencies
                self.customActivityIndicator.alpha = 0.0
                self.customActivityIndicator.stopAnimating()
                CoreDataService.shared.clearEntityOf(type: Currency.self)
                CoreDataService.shared.saveDataFrom(array: currencies)
                UIView.animate(withDuration: 0.3) {
                    self.tableView.alpha = 1.0
                }
                self.tableView.reloadData()
            case .failure(_):
                self.showErrorAlert()
            }
        }
    }
    
    private func loadFromCoreData() {
        do {
            try fetchedResultsController.performFetch()
        } catch (let fetchError){
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    private func showErrorAlert() {
        customActivityIndicator.alpha = 0.0
        customActivityIndicator.stopAnimating()
        DispatchQueue.main.async {
            self.present((self.presentErrorAlert { [weak self] result in
                guard let self = self else { return }
                self.customActivityIndicator.alpha = 1.0
                self.customActivityIndicator.startAnimating()
                self.requestCurrencies()
            }), animated: true)
        }
    }
    
    private func setupViews() {
        view.addSubview(customActivityIndicator)
        view.addSubview(tableView)
        
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

// MARK: - UITableViewDelegate

extension CryptoCurrenciesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: CryptoCurrenciesHeaderView.reuseId)
                as? CryptoCurrenciesHeaderView
        else {
            return nil
        }
        
        headerView.delegate = self
        headerView.configureHeaderLabel(orderByString)
        
        return headerView
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension CryptoCurrenciesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard
            let maxRow = indexPaths.map({ $0.row }).max()
        else { return }
        
        let previousQuntity = currencies.count
        
        if maxRow > previousQuntity - 10,
           isLoading == false {
            
            isLoading = true
            networkService.getAllCoins(page: page) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let items):
                    print(items)
                    guard items.count > 0 else { return }
                    
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
                case .failure(_):
                    self.showErrorAlert()
                }
                
            }
        }
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
        present(getOrderActionSheet(handler: { [weak self] result in
            guard let self = self else { return }
            switch result.title {
            case Constants.OrderCryptoCurrencyText.marketCap.rawValue:
                self.filterCurrencies = self.filterCurrencies.sorted { $0.marketCap > $1.marketCap }
                self.orderByString = Constants.OrderCryptoCurrencyText.marketCap.rawValue
                self.tableView.reloadData()
                self.dismiss(animated: true)
            case Constants.OrderCryptoCurrencyText.volume.rawValue:
                self.filterCurrencies = self.filterCurrencies.sorted { $0.totalVolume > $1.totalVolume }
                self.orderByString = Constants.OrderCryptoCurrencyText.volume.rawValue
                self.tableView.reloadData()
                self.dismiss(animated: true)
            case Constants.OrderCryptoCurrencyText.price.rawValue:
                self.filterCurrencies = self.filterCurrencies.sorted { $0.currentPrice > $1.currentPrice }
                self.orderByString = Constants.OrderCryptoCurrencyText.price.rawValue
                self.tableView.reloadData()
                self.dismiss(animated: true)
            case Constants.OrderCryptoCurrencyText.name.rawValue:
                self.filterCurrencies = self.filterCurrencies.sorted { $1.name > $0.name }
                self.orderByString = Constants.OrderCryptoCurrencyText.name.rawValue
                self.tableView.reloadData()
                self.dismiss(animated: true)
            case Constants.OrderCryptoCurrencyText.percentChange.rawValue:
                self.filterCurrencies = self.filterCurrencies.sorted { $0.priceChangePercentage24H ?? 0 > $1.priceChangePercentage24H ?? 0 }
                self.orderByString = Constants.OrderCryptoCurrencyText.percentChange.rawValue
                self.tableView.reloadData()
                self.dismiss(animated: true)
            case Constants.OrderCryptoCurrencyText.rank.rawValue:
                self.filterCurrencies = self.filterCurrencies.sorted { $0.marketCapRank < $1.marketCapRank }
                self.orderByString = Constants.OrderCryptoCurrencyText.rank.rawValue
                self.tableView.reloadData()
                self.dismiss(animated: true)
            case .none:
                print("nothing")
            case .some(_):
                print("some")
            }
        }), animated: true)
    }
}
