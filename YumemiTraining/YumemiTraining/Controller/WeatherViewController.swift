//
//  WeatherViewController.swift
//  YumemiTraining
//
//  Created by Daichi Hayashi on 2021/04/10.
//

import UIKit

final class WeatherViewController: UIViewController, WeatherViewDelegate {

    private let weatherView: WeatherViewProtocol = WeatherView()
    private let weatherFetcher: WeatherFetcherProtocol = WeatherFetcher()

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
        let weather = weatherFetcher.fetch()
        let viewState = WeatherViewState(weather: weather)

        weatherView.setWeatherImage(image: viewState.image,
                                    color: viewState.color)
    }
}

