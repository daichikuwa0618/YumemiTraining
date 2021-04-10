//
//  WeatherView.swift
//  YumemiTraining
//
//  Created by Daichi Hayashi on 2021/04/10.
//

import UIKit

final class WeatherView: UIView {

    private let imageLabelStackView: UIStackView = UIStackView()
    private let labelStackView: UIStackView = UIStackView()
    private let weatherImageView: UIImageView = UIImageView()
    private let maxTemperatureLabel: UILabel = UILabel()
    private let minTemperatureLabel: UILabel = UILabel()

    private let closeButton: UIButton = UIButton(type: .system)
    private let reloadButton: UIButton = UIButton(type: .system)

    override func layoutSubviews() {
        super.layoutSubviews()

        setup()
    }

    private func setup() {
        backgroundColor = .systemBackground

        setupSubviews()
    }

    private func setupSubviews() {
        setupImageLabelStackView()
        setupLabelStackView()
        setupWeatherImageView()
        setupTemperatureLabels()
        setupButtons()
    }

    private func setupImageLabelStackView() {
        addSubview(imageLabelStackView)

        imageLabelStackView.addArrangedSubview(weatherImageView)
        imageLabelStackView.addArrangedSubview(labelStackView)

        imageLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        imageLabelStackView.axis = .vertical

        NSLayoutConstraint.activate([
            imageLabelStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageLabelStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    private func setupLabelStackView() {
        labelStackView.addArrangedSubview(minTemperatureLabel)
        labelStackView.addArrangedSubview(maxTemperatureLabel)

        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .horizontal
    }

    private func setupWeatherImageView() {
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            weatherImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            weatherImageView.heightAnchor.constraint(equalTo: weatherImageView.widthAnchor)
        ])
    }

    private func setupTemperatureLabels() {
        minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false

        minTemperatureLabel.text = "--"
        maxTemperatureLabel.text = "--"
        minTemperatureLabel.textColor = .systemBlue
        maxTemperatureLabel.textColor = .systemRed
        minTemperatureLabel.textAlignment = .center
        maxTemperatureLabel.textAlignment = .center

        NSLayoutConstraint.activate([
            minTemperatureLabel.widthAnchor.constraint(equalTo: weatherImageView.widthAnchor, multiplier: 0.5),
            maxTemperatureLabel.widthAnchor.constraint(equalTo: weatherImageView.widthAnchor, multiplier: 0.5)
        ])
    }

    private func setupButtons() {
        addSubview(closeButton)
        addSubview(reloadButton)

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.translatesAutoresizingMaskIntoConstraints = false

        closeButton.setTitle("Close", for: .normal)
        reloadButton.setTitle("Reload", for: .normal)

        closeButton.addAction(.init { _ in self.tapClose() }, for: .touchUpInside)
        reloadButton.addAction(.init { _ in self.tapReload() }, for: .touchUpInside)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: imageLabelStackView.bottomAnchor, constant: 80),
            reloadButton.topAnchor.constraint(equalTo: imageLabelStackView.bottomAnchor, constant: 80),
            closeButton.centerXAnchor.constraint(equalTo: minTemperatureLabel.centerXAnchor),
            reloadButton.centerXAnchor.constraint(equalTo: maxTemperatureLabel.centerXAnchor)
        ])
    }

    @objc
    private func tapClose() {
        print("Close button tapped.")
    }

    @objc
    private func tapReload() {
        print("Reload button tapped.")
    }
}
