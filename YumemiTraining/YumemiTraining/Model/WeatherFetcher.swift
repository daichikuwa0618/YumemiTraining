//
//  WeatherFetcher.swift
//  YumemiTraining
//
//  Created by Daichi Hayashi on 2021/04/13.
//

import Foundation

import YumemiWeather

protocol WeatherFetcherProtocol {
    func fetch() -> Weather
}

final class WeatherFetcher: WeatherFetcherProtocol {
    func fetch() -> Weather {
        let fetchedString: String = YumemiWeather.fetchWeather()
        let weather: Weather = {
            switch fetchedString {
            case "sunny":
                return .sunny

            case "cloudy":
                return .cloudy

            case "rainy":
                return .rainy

            default:
                assertionFailure("unexpected string was returned.")
                return .cloudy
            }
        }()

        return weather
    }
}
