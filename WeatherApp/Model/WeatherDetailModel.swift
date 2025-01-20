//
//  WeatherDetailModel.swift
//  WeatherApp
//
//  Created by zhu on 2025/1/19.
//

import Foundation

struct WeatherDetailModel: Codable {
    var latitude: Double?
    var longitude: Double?
    var hourlyUnits: HourlyUnits?
    var hourly: Hourly?
    
    enum CodingKeys : String, CodingKey{
        case latitude
        case longitude
        case hourlyUnits = "hourly_units"
        case hourly
    }

    struct HourlyUnits: Codable {
        var time: String?
        var temperature2m: String?

        enum CodingKeys : String, CodingKey{
            case time
            case temperature2m = "temperature_2m"
        }
    }

    struct Hourly: Codable {
        var time: [Date]?
        var temperature2m: [Float]?

        enum CodingKeys : String, CodingKey{
            case time
            case temperature2m = "temperature_2m"
        }
    }
}

struct WeatherHourDetailVO {
    var time: Date?
    var timeStr: String?
    var temperature: Float?
    var temperatureStr: String?
}

struct WeatherDayDetailVO {
    var time: Date?
    var timeStr: String?
    var detailVOs: [WeatherHourDetailVO]?
}
