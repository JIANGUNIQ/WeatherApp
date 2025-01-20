//
//  LocationService.swift
//  WeatherApp
//
//  Created by zhu on 2025/1/19.
//

import Foundation
import CoreLocation
import RxSwift

class LocationService:NSObject{
    private let locationManager = CLLocationManager()
    let locationSubject = PublishSubject<CLLocationCoordinate2D?>()
    
    override init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    func requestLocation() {
        if locationManager.authorizationStatus == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }else{
            locationManager.requestLocation()
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationSubject.onNext(location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationSubject.onNext(nil)
    }
}
