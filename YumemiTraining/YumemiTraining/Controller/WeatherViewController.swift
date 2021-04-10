//
//  WeatherViewController.swift
//  YumemiTraining
//
//  Created by Daichi Hayashi on 2021/04/10.
//

import UIKit

final class WeatherViewController: UIViewController {

    private let weatherView: WeatherView = WeatherView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupWeatherView()
    }

    private func setupWeatherView() {
        view.addSubview(weatherView)
        weatherView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            weatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

