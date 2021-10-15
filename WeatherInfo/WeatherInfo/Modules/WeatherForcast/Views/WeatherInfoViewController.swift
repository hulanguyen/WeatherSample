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
    }
    
    private func setupTableView() {
        let cell = UINib(nibName: ConstantKeys.kweatherInfoCellNibName, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: ConstantKeys.kWeatherInfoCellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160.0
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
