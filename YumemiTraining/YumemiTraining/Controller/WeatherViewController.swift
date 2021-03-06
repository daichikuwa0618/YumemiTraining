//
//  WeatherViewController.swift
//  YumemiTraining
//
//  Created by Daichi Hayashi on 2021/04/10.
//

import Foundation
import OSLog
import UIKit

protocol LoadingView: UIView {
    func start()
    func stop()
}

final class WeatherViewController: UIViewController, WeatherViewDelegate {

    // MARK: - Private property

    private let weatherView: WeatherViewProtocol
    private let loadingView: LoadingView
    private var weatherFetcher: WeatherFetcherProtocol

    // MARK: - initializer

    init(weatherView: WeatherViewProtocol, loadingView: LoadingView, weatherFetcher: WeatherFetcherProtocol) {
        self.weatherView = weatherView
        self.loadingView = loadingView
        self.weatherFetcher = weatherFetcher

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        Logger().info("WeatherViewController has been deinitialized.")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupWeatherView()
        setupNotificationCenter()
        setupLoadingView()
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

    private func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.isUserInteractionEnabled = true
        loadingView.isHidden = true

        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }

    private func showLoadingView() {
        loadingView.isHidden = false
        loadingView.start()
    }

    private func dismissLoadingView() {
        loadingView.stop()
        loadingView.isHidden = true
    }

    func updateWeatherView(from response: WeatherResponse) {
        let viewEntity = WeatherViewEntity(weather: response.weather,
                                           maxTemperature: response.maxTemperature,
                                           minTemperature: response.minTemperature)
        let viewState = WeatherViewState(weather: viewEntity.weather)

        self.weatherView.setWeatherImage(image: viewState.image,
                                         color: viewState.color)
        self.weatherView.setTemperature(max: viewEntity.maxTemperature,
                                        min: viewEntity.minTemperature)
    }

    func showErrorAlert(_ error: Error) {
        if let error = error as? AppError {
            let message: String = {
                switch error {
                case .invalidParameter:
                    return "?????????????????????????????????"

                case .parse:
                    return "????????????????????????????????????"

                case .unknown:
                    return "????????????????????????"

                case .unexpected:
                    return "???????????????????????????"
                }
            }()

            let alert: UIAlertController = ErrorAlert.createCloseAlert(title: "??????????????????????????????",
                                                                       message: message)

            self.present(alert, animated: true)

        } else {
            assertionFailure("unexpected")
            let alert: UIAlertController = ErrorAlert.createCloseAlert(title: "??????????????????????????????",
                                                                       message: "???????????????????????????")

            self.present(alert, animated: true)
        }
    }

    // MARK: - WeatherViewDelegate
    func close() {
        dismiss(animated: true)
    }

    @objc
    func reload() {
        DispatchQueue.main.async {
            self.showLoadingView()
        }

        weatherFetcher.fetch { [weak self] result in
            guard let self = self else { return }

            do {
                let response = try result.get()

                DispatchQueue.main.async {
                    self.updateWeatherView(from: response)
                    self.dismissLoadingView()
                }
            } catch {
                DispatchQueue.main.async {
                    self.showErrorAlert(error)
                    self.dismissLoadingView()
                }
            }
        }
    }
}

