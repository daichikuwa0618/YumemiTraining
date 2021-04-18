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
            let decoder: JSONDecoder = JSONDecoder()
            let value: WeatherResponse = try decoder.decode(WeatherResponse.self, from: data)

            return value
        } catch {
            throw AppError.parse
        }
    }
}
