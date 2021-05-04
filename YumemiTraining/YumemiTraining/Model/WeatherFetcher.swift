//
//  WeatherFetcher.swift
//  YumemiTraining
//
//  Created by Daichi Hayashi on 2021/04/13.
//

import Foundation

import YumemiWeather

protocol WeatherFetcherProtocol {
    func fetch(completionHandler: @escaping (Result<WeatherResponse, AppError>) -> Void)
}

final class WeatherFetcher: WeatherFetcherProtocol {

    // MARK: - Private property

    private let dateFormatter: DateFormatterUtilProtocol

    // MARK: - Initializer

    init(dateFormatter: DateFormatterUtilProtocol) {
        self.dateFormatter = dateFormatter
    }

    // MARK: - WeatherFetcherProtocol

    func fetch(completionHandler: @escaping (Result<WeatherResponse, AppError>) -> Void) {
        DispatchQueue.global().async {
            let result: Result<WeatherResponse, AppError>

            do {
                let inputJsonString: String = try self.createPostJSONString(with: Date())
                let fetchedData: Data = try Data(YumemiWeather.fetchWeather(inputJsonString).utf8)

                let response = try self.parseWeatherResponse(from: fetchedData)

                result = .success(response)

            } catch YumemiWeatherError.invalidParameterError {
                result = .failure(.invalidParameter)

            } catch YumemiWeatherError.unknownError {
                result = .failure(.unknown)

            } catch AppError.parse {
                result = .failure(.parse)

            } catch {
                result = .failure(.unexpected)
            }

            completionHandler(result)
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

    private func createPostJSONString(with date: Date) throws -> String {
        do {
            let encoder: JSONEncoder = JSONEncoder()
            let dateString: String = dateFormatter.createString(from: date)
            let object: WeatherPostObject = WeatherPostObject(area: "Tokyo",
                                                              dateString: dateString)

            let data: Data = try encoder.encode(object)

            return String(decoding: data, as: UTF8.self)

        } catch {
            throw AppError.parse
        }
    }
}
