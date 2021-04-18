//
//  WeatherViewController.swift
//  YumemiTraining
//
//  Created by Daichi Hayashi on 2021/04/10.
//

import UIKit

final class WeatherViewController: UIViewController, WeatherViewDelegate {

    private let weatherView: WeatherViewProtocol = WeatherView()
    private let weatherFetcher: WeatherFetcherProtocol = WeatherFetcher(dateFormatter: DateFormatterUtil())

    override func viewDidLoad() {
        super.viewDidLoad()

        setupWeatherView()
    }

    private func setupWeatherView() {
        view.addSubview(weatherView)
        weatherView.delegate = self
        weatherView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            weatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }

    // MARK: - WeatherViewDelegate
    func close() {
        print("close")
    }

    func reload() {
        do {
            let weather = try weatherFetcher.fetch()
            let viewState = WeatherViewState(weather: weather.weather)

            weatherView.setWeatherImage(image: viewState.image,
                                        color: viewState.color)
            weatherView.setTemperature(max: weather.maxTemperature,
                                       min: weather.minTemperature)

        } catch let error as AppError {
            let message: String = {
                switch error {
                case .invalidParameter:
                    return "入力された値が不正です"

                case .parse:
                    return "情報の変換に失敗しました"

                case .unknown:
                    return "不明なエラーです"

                case .unexpected:
                    return "予期せぬエラーです"
                }
            }()

            let alert: UIAlertController = ErrorAlert.createCloseAlert(title: "エラーが発生しました",
                                                                       message: message)

            present(alert, animated: true)

        } catch {
            assertionFailure("unexpected")
            let alert: UIAlertController = ErrorAlert.createCloseAlert(title: "エラーが発生しました",
                                                                       message: "予期せぬエラーです")
            present(alert, animated: true)
        }
    }
}

