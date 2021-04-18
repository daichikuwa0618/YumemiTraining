//
//  WeatherFetcher.swift
//  YumemiTraining
//
//  Created by Daichi Hayashi on 2021/04/13.
//

import Foundation

import YumemiWeather

protocol WeatherFetcherProtocol {
    func fetch() throws -> WeatherResponse
}

final class WeatherFetcher: WeatherFetcherProtocol {

    // MARK: - Private property

    private let dateFormatter: DateFormatterUtilProtocol

    // MARK: - Initializer

    init(dateFormatter: DateFormatterUtilProtocol) {
        self.dateFormatter = dateFormatter
    }

    // MARK: - WeatherFetcherProtocol

    func fetch() throws -> WeatherResponse {
        do {
            let nowDateString: String = dateFormatter.createString(from: Date())
            let inputJsonString: String = #"{"area": "Tokyo", "date": "\#(nowDateString)"}"#
            let fetchedData: Data = try Data(YumemiWeather.fetchWeather(inputJsonString).utf8)

            let response = try parseWeatherResponse(from: fetchedData)

            return response
        } catch YumemiWeatherError.invalidParameterError {
            throw AppError.invalidParameter

        } catch YumemiWeatherError.unknownError {
            throw AppError.unknown

        } catch AppError.parse {
            throw AppError.parse

        } catch {
            throw AppError.unexpected
        }
    }

    private func createWeather(from string: String) -> Weather? {
        switch string {
        case "sunny":
            return .sunny

        case "cloudy":
            return .cloudy

        case "rainy":
            return .rainy

        default:
            return nil
        }
    }

    private func parseWeatherResponse(from data: Data) throws -> WeatherResponse {
        do {
            guard let jsonDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let weatherValue = jsonDictionary["weather"] as? String,
                  let weather = createWeather(from: weatherValue),
                  let maxTempValue = jsonDictionary["max_temp"] as? Int,
                  let minTempValue = jsonDictionary["min_temp"] as? Int,
                  let dateValue = jsonDictionary["date"] as? String,
                  let date = dateFormatter.createDate(from: dateValue) else {
                throw AppError.parse
            }

            let response = WeatherResponse(
                weather: weather,
                maxTemperature: maxTempValue,
                minTemperature: minTempValue,
                date: date
            )

            return response
        } catch {
            throw AppError.parse
        }
    }
}
