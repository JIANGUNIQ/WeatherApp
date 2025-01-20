//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by zhu on 2025/1/19.
//

import Foundation
import RxSwift
import Alamofire

enum RequestState {
   case Loading
   case Success
   case Error
}

class WeatherDetailViewModel{
    private let apiService = ApiService()
    private let locationService = LocationService()
    private let disposeBag = DisposeBag()
    private var requestDisposable:Disposable?
    
    private(set) var requestSubject = PublishSubject<RequestState>()
    
    private(set) var datasource = [WeatherDayDetailVO]()
    
    init(){
        
    }
    
    /**
     * 1、request location coordinate,use default value if request fail
     * 2、request weather forecast
     */
    func requestLocationAndWeatherData(){
        if let requestDisposable = requestDisposable {
            requestDisposable.dispose()
        }
        requestSubject.onNext(.Loading)
        
        var params = ["latitude":"52.52","longitude":"13.41","hourly":"temperature_2m"]
        requestDisposable = locationService.locationSubject.asObserver().flatMap { [weak self] coord -> Observable<WeatherDetailModel> in
            if let coord = coord {
                params["latitude"] = String(coord.latitude)
                params["longitude"] = String(coord.longitude)
            }
            return self?.apiService.getWeatherData(params: params) ?? Observable<WeatherDetailModel>.empty()
        }.subscribe { [weak self] model in
            self?.transformResponseData(model: model)
            self?.requestSubject.onNext(.Success)
        } onError: { [weak self] e in
            self?.requestSubject.onNext(.Error)
        }
        
        locationService.requestLocation()
    }
    
    
    private func transformResponseData(model:WeatherDetailModel?){
        guard let detailModel = model  else{
            return
        }
        
        var dayDataDic = [String:WeatherDayDetailVO]()
        if let timeArray = detailModel.hourly?.time, let temperatureArray = model?.hourly?.temperature2m  {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            
            for (index, date) in timeArray.enumerated() {
                var hourDetailVO = WeatherHourDetailVO()
                hourDetailVO.time = date
                hourDetailVO.timeStr = dateFormatter.string(from: date)
                hourDetailVO.temperature = index < temperatureArray.count ? temperatureArray[index] : 0
                hourDetailVO.temperatureStr = "\(hourDetailVO.temperature!)°C"
                
                if let timeStr = hourDetailVO.timeStr {
                    let dayStr = String(timeStr.prefix(10))
                    hourDetailVO.timeStr = String(timeStr.suffix(5))
                    var dayDetailVO =  dayDataDic[dayStr]
                    
                    if dayDetailVO != nil {
                        dayDetailVO!.detailVOs?.append(hourDetailVO)
                        dayDataDic[dayStr] = dayDetailVO
                    }else{
                        var dayDetailVO = WeatherDayDetailVO()
                        dayDetailVO.time = date
                        dayDetailVO.timeStr = dayStr
                        dayDetailVO.detailVOs = [hourDetailVO]
                        dayDataDic[dayStr] = dayDetailVO
                    }
                }
            }
        }
     
        let dayDetailVOs = dayDataDic.sorted{(item1, item2) -> Bool in
            return item1.key < item2.key
        }.compactMap { $1 }
        
        datasource.removeAll()
        datasource.append(contentsOf: dayDetailVOs)
    }
}
