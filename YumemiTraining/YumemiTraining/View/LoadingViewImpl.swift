//
//  LoadingViewImpl.swift
//  YumemiTraining
//
//  Created by Daichi Hayashi on 2021/05/04.
//

import UIKit

final class LoadingViewImpl: UIView, LoadingView {

    // MARK: - private property

    private let indicatorView: UIActivityIndicatorView = .init(style: .large)
    private let backgroundView: UIView = .init()

    override func layoutSubviews() {
        super.layoutSubviews()

        setupBackground()
        setupIndicatorView()
    }

    // MARK: - private function

    private func setupBackground() {
        addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor(named: "loadingBackground")
        backgroundView.layer.cornerRadius = 4

        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: 100),
            backgroundView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func setupIndicatorView() {
        addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.hidesWhenStopped = true
        indicatorView.color = UIColor(named: "loadingIndicator")

        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
        ])
    }

    // MARK: - LoadingView

    func start() {
        indicatorView.startAnimating()
    }

    func stop() {
        indicatorView.stopAnimating()
    }
}
