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
        presenter.listWeatherForcast
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.tableView.reloadData()
            }.disposed(by: disposeBag)
        
        bindErrorData()
    }
    
    func bindErrorData() {
        presenter
            .error
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] error in
                self?.handleErrorMessage(error: error)
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
