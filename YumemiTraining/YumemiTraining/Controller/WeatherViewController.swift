//
//  WeatherViewController.swift
//  YumemiTraining
//
//  Created by Daichi Hayashi on 2021/04/10.
//

import Foundation
import UIKit

final class WeatherViewController: UIViewController, WeatherViewDelegate {

    // MARK: - Private property

    private let weatherView: WeatherViewProtocol
    private let weatherFetcher: WeatherFetcherProtocol

    // MARK: - initializer

    init(weatherView: WeatherViewProtocol, weatherFetcher: WeatherFetcherProtocol) {
        self.weatherView = weatherView
        self.weatherFetcher = weatherFetcher

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupWeatherView()
        setupNotificationCenter()
    }

    // MARK: - Private method

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

    private func setupNotificationCenter() {
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(reload),
                           name: UIApplication.didBecomeActiveNotification,
                           object: nil)
    }

    // MARK: - WeatherViewDelegate
    func close() {
        dismiss(animated: true)
    }

    @objc
    func reload() {
        do {
            let response = try weatherFetcher.fetch()
            let viewEntity = WeatherViewEntity(weather: response.weather,
                                               maxTemperature: response.maxTemperature,
                                               minTemperature: response.minTemperature)
            let viewState = WeatherViewState(weather: viewEntity.weather)

            weatherView.setWeatherImage(image: viewState.image,
                                        color: viewState.color)
            weatherView.setTemperature(max: viewEntity.maxTemperature,
                                       min: viewEntity.minTemperature)

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

