//
//  WeatherInfoViewController.swift
//  WeatherInfo
//
//  Created by Lam Nguyen Huu (VN) on 13/10/2021.
//

import UIKit
import RxSwift

class WeatherInfoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let presenter: WeatherInfoPresenter
    let disposeBag = DisposeBag()
    
    init(presenter: WeatherInfoPresenter) {
        self.presenter = presenter
        super.init(nibName: "WeatherInfoViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        presenter.loadWeatherInfo(name: "saigon")
        
    }

    func setupUI() {
        navigationItem.title = ConstantKeys.kWeatherSearchScreenNavigationTitle
        setupTableView()
        setupSearchBar()
    }

    private func setupSearchBar() {
        searchBar.delegate = self
//        searchBar.accessibilityLabel = "Search Bar"
        searchBar.searchTextField.accessibilityLabel = "Search Bar Text Field"
        searchBar.searchTextField.font = UIFont.preferredFont(forTextStyle: .body)
        searchBar.searchTextField.adjustsFontForContentSizeCategory = true
    }
    
    private func setupTableView() {
        let cell = UINib(nibName: ConstantKeys.kweatherInfoCellNibName, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: ConstantKeys.kWeatherInfoCellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = ConstantKeys.kHeightOfWeatherInfoCell
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func bindViewModel() {
        presenter.listWeatherForcast
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.tableView.reloadData()
            }.disposed(by: disposeBag)
        
        bindErrorData()
    }
    
    private func bindErrorData() {
        presenter
            .errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] message in
                self?.showAlert(title: ConstantKeys.kErrorTitleAlert, message: message)
            }
            .disposed(by: disposeBag)
    }
    
    private func showAlert(title: String, message: String) {
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
}

extension WeatherInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.listWeatherForcast.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConstantKeys.kWeatherInfoCellReuseIdentifier, for: indexPath) as! WeatherInfoTableViewCell
        cell.setup(data: presenter.listWeatherForcast.value[indexPath.row])
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        ConstantKeys.kHeightOfWeatherInfoCell
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        presenter.headerTitle
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let myLabel = UILabel()
        
        myLabel.font = UIFont.boldSystemFont(ofSize: 18)
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        myLabel.font = UIFont.preferredFont(forTextStyle: .body)
        myLabel.adjustsFontForContentSizeCategory = true
        
        let headerView = UIView()
        headerView.addSubview(myLabel)
        
        
            myLabel.translatesAutoresizingMaskIntoConstraints = false
            let topAnchor = myLabel.topAnchor.constraint(equalTo: headerView.topAnchor)
            let bottomAnchor = myLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
            let leadingAnchor = myLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10)
            let trailingAnchor = myLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor)
            NSLayoutConstraint.activate([topAnchor, bottomAnchor, leadingAnchor, trailingAnchor])
        
        
        headerView.backgroundColor = view.backgroundColor
        return headerView
    }
}

extension WeatherInfoViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchName = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if presenter.searchName.count >= 3 {
            presenter.loadWeatherInfo(name: presenter.searchName)
        } else {
            showAlert(title: ConstantKeys.kWarningTitleAlert, message: ConstantKeys.kWaringMessageSearchNameLessThan3)
        }
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
