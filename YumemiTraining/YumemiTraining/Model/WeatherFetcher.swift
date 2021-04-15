//
//  WeatherFetcher.swift
//  YumemiTraining
//
//  Created by Daichi Hayashi on 2021/04/13.
//

import Foundation

import YumemiWeather

protocol WeatherFetcherProtocol {
    func fetch() throws -> Weather
}

final class WeatherFetcher: WeatherFetcherProtocol {
    func fetch() throws -> Weather {
        do {
            let fetchedString: String = try YumemiWeather.fetchWeather(at: "Tokyo")
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
        } catch YumemiWeatherError.invalidParameterError {
            throw AppError.invalidParameter

        } catch YumemiWeatherError.unknownError {
            throw AppError.unknown

        } catch {
            throw AppError.unexpected
        }
    }
}
