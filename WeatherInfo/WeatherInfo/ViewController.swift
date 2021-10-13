//
//  ViewController.swift
//  WeatherInfo
//
//  Created by Lam Nguyen Huu (VN) on 11/10/2021.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let viewModel = WeatherInfoViewModel(service: NetworksAPI())
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        viewModel.getWeatherForcast(name: "saigon")
        
    }

    func setupUI() {
        navigationItem.title = ConstantKeys.kWeatherSearchScreenNavigationTitle
        setupTableView()
        setupSearchBar()
    }

    func setupSearchBar() {
        searchBar.delegate = self
    }
    
    func setupTableView() {
        let cell = UINib(nibName: ConstantKeys.kweatherInfoCellNibName, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: ConstantKeys.kWeatherInfoCellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func bindViewModel() {
        viewModel.weatherDatas
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
            self?.tableView.reloadData()
            }.disposed(by: disposeBag)
        
        bindErrorData()
    }
    
    func bindErrorData() {
        viewModel
            .error
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] error in
            self?.handleErrorMessage(error: error)
        } onError: { _ in
        }
        .disposed(by: disposeBag)
    }
    
    func handleErrorMessage(error: Error) {
        guard let resError = error as? ResponseError else {
            return
        }
        var message = ""
        switch resError {
        case .netWorkNotFound:
            message = "Net work not found. Please check your connection."
        case .clientError(let error):
            message = error.message
        case .serverError(let error):
            message = error.localizedDescription
        case .parsingError:
            message = "Can not parse data response on server."
        case .unknowError:
            message = "Unknow issue"
        }
        showAlert(message: message)
    }
    
    func showAlert(message: String) {
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let alertVC = UIAlertController(title: "Error Message", message: message, preferredStyle: .alert)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.weatherDatas.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConstantKeys.kWeatherInfoCellReuseIdentifier, for: indexPath) as! WeatherInfoTableViewCell
        cell.setup(data: viewModel.weatherDatas.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160.0
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchname = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if viewModel.searchname.count >= 3 {
            viewModel.getWeatherForcast(name: viewModel.searchname)
        } else {
            showAlert(message: "Search term length must be from 3 characters or above")
        }
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
