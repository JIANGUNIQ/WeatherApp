//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by zhu on 2025/1/19.
//


import UIKit
import RxSwift

class WeatherDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chartView: WeatherDetailChartView!

    let disposeBag = DisposeBag()
    let detailViewModel = WeatherDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initViews()
        initObserver()
        detailViewModel.requestLocationAndWeatherData()
    }
    
    func initViews(){
        self.tableView.layer.cornerRadius = 10
    }
    
    func initObserver(){
        detailViewModel.requestSubject.subscribe(onNext: { [weak self] state in
            self?.updateView(state: state)
        }).disposed(by: disposeBag)
    }
    
    func updateView(state:RequestState) {
        switch state {
        case .Loading:
            self.loadingView.isHidden = false
            self.errorView.isHidden = true
            self.contentView.isHidden = true
            
        case .Success:
            self.loadingView.isHidden = true
            self.errorView.isHidden = true
            self.contentView.isHidden = false
            self.tableView.reloadData()
            
            if let dayDetailVO = detailViewModel.datasource.first {
                self.chartView.updateView(vo: dayDetailVO)
            }
            
        case .Error:
            self.loadingView.isHidden = true
            self.errorView.isHidden = false
            self.contentView.isHidden = true
        }
    }
    
    @IBAction func retryAction(_ sender: Any) {
        detailViewModel.requestLocationAndWeatherData()
    }
    
    // MARK: - UITableViewDelegate UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailViewModel.datasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detailCell = tableView.dequeueReusableCell(withIdentifier: "WeatherDayDetailCell", for: indexPath) as! WeatherDayDetailCell
        let detailVO = detailViewModel.datasource[indexPath.row]
        detailCell.updateView(vo: detailVO)
        
        return detailCell
    }
    
    
}

