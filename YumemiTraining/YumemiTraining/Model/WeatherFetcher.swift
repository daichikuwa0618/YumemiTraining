//
//  WeatherFetcher.swift
//  YumemiTraining
//
//  Created by Daichi Hayashi on 2021/04/13.
//

import Foundation

import YumemiWeather

protocol WeatherFetcherDelegate: AnyObject {
    func handleResponse(_ response: WeatherResponse)
    func handleError(_ error: AppError)
}

protocol WeatherFetcherProtocol {
    var delegate: WeatherFetcherDelegate? { get set }

    func fetch()
}

final class WeatherFetcher: WeatherFetcherProtocol {

    // MARK: - Internal property

    weak var delegate: WeatherFetcherDelegate?

    // MARK: - Private property

    private let dateFormatter: DateFormatterUtilProtocol

    // MARK: - Initializer

    init(dateFormatter: DateFormatterUtilProtocol) {
        self.dateFormatter = dateFormatter
    }

    // MARK: - WeatherFetcherProtocol

    func fetch() {
        DispatchQueue.global().async {
            do {
                let inputJsonString: String = try self.createPostJSONString(with: Date())
                let fetchedData: Data = try Data(YumemiWeather.syncFetchWeather(inputJsonString).utf8)

                let response = try self.parseWeatherResponse(from: fetchedData)

                self.delegate?.handleResponse(response)

            } catch YumemiWeatherError.invalidParameterError {
                self.delegate?.handleError(.invalidParameter)

            } catch YumemiWeatherError.unknownError {
                self.delegate?.handleError(.unknown)

            } catch AppError.parse {
                self.delegate?.handleError(.parse)

            } catch {
                self.delegate?.handleError(.unexpected)
            }
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
