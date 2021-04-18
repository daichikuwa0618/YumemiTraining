//
//  WeatherResponse.swift
//  YumemiTraining
//
//  Created by Daichi Hayashi on 2021/04/17.
//

import Foundation

struct WeatherResponse: Decodable {
    let weather: Weather
    let maxTemperature: Int
    let minTemperature: Int
    let dateString: String

    private enum CodingKeys: String, CodingKey {
        case weather
        case maxTemperature = "max_temp"
        case minTemperature = "min_temp"
        case dateString = "date"
    }
}
