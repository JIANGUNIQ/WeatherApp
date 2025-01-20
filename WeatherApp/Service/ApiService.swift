//
//  ApiService.swift
//  WeatherApp
//
//  Created by zhu on 2025/1/19.
//

import Foundation
import Alamofire
import RxSwift

class ApiService{
    let jsonDecoder = JSONDecoder()
    init(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    func getWeatherData(params:[String:Any]?) -> Observable<WeatherDetailModel>{
        return Observable<WeatherDetailModel>.create{ observer in
            let request = AF.request("https://api.open-meteo.com/v1/forecast",method: .get,parameters: params).responseDecodable(of: WeatherDetailModel.self, decoder: self.jsonDecoder) { response in
                switch response.result {
                case .success(let data):
                    observer.onNext(data)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create{
                request.cancel()
            }
        }
        
    }
    
}
