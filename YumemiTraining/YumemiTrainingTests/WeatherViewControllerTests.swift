//
//  WeatherViewControllerTests.swift
//  YumemiTrainingTests
//
//  Created by Daichi Hayashi on 2021/04/10.
//

import XCTest
@testable import YumemiTraining

class WeatherViewControllerTests: XCTestCase {

    func test_sunnyのときの画像() {
        let response: WeatherResponse = .init(weather: .sunny,
                                              maxTemperature: 0,
                                              minTemperature: 0,
                                              dateString: "")
        let vc = prepareForViewTesting(response: response)
        let imageView = getImageView(from: vc)

        let expectation = WeatherViewState(weather: .sunny).image

        XCTAssertEqual(imageView.image, expectation)
    }

    func test_cloudyのときの画像() {
        let response: WeatherResponse = .init(weather: .cloudy,
                                              maxTemperature: 0,
                                              minTemperature: 0,
                                              dateString: "")
        let vc = prepareForViewTesting(response: response)
        let imageView = getImageView(from: vc)

        let expectation = WeatherViewState(weather: .cloudy).image

        XCTAssertEqual(imageView.image, expectation)
    }

    func test_rainyのときの画像() {
        let response: WeatherResponse = .init(weather: .rainy,
                                              maxTemperature: 0,
                                              minTemperature: 0,
                                              dateString: "")
        let vc = prepareForViewTesting(response: response)
        let imageView = getImageView(from: vc)

        let expectation = WeatherViewState(weather: .rainy).image

        XCTAssertEqual(imageView.image, expectation)
    }

    func test_最高気温と最低気温が反映される() {
        let maxExpectation: Int = .random(in: 1...1000)
        let minExpectation: Int = .random(in: (-1000)...(-1))

        let response: WeatherResponse = .init(weather: .sunny,
                                              maxTemperature: maxExpectation,
                                              minTemperature: minExpectation,
                                              dateString: "")
        let vc = prepareForViewTesting(response: response)
        let labels = getTempLabels(from: vc)
        vc.reload()

        XCTAssertEqual(labels.max.text!, String(describing: maxExpectation))
        XCTAssertEqual(labels.min.text!, String(describing: minExpectation))
    }

    private func prepareForViewTesting(response: WeatherResponse) -> WeatherViewController {
        let fetcher: MockWeatherFetcher = .init(isThrow: false, response: response)

        let vc: WeatherViewController = .init(weatherView: WeatherView(), weatherFetcher: fetcher)
        vc.loadViewIfNeeded()
        vc.reload()

        return vc
    }

    private func getImageView(from vc: WeatherViewController) -> UIImageView {
        let weatherView: WeatherView = vc.view.subviews.first! as! WeatherView
        weatherView.layoutIfNeeded()
        let stackView: UIStackView = weatherView.subviews.first(where: { $0 is UIStackView })! as! UIStackView
        let imageView: UIImageView = stackView.subviews.first(where: { $0 is UIImageView })! as! UIImageView

        return imageView
    }

    private func getTempLabels(from vc: WeatherViewController) -> (max: UILabel, min: UILabel) {
        let weatherView: WeatherView = vc.view.subviews.first! as! WeatherView
        weatherView.layoutIfNeeded()
        let stackView: UIStackView = weatherView.subviews.compactMap { $0 as? UIStackView }.first!
        let labelStack: UIStackView = stackView.arrangedSubviews.compactMap { $0 as? UIStackView }.first!

        return (labelStack.arrangedSubviews[1] as! UILabel, labelStack.arrangedSubviews[0] as! UILabel)
    }
}

private struct MockWeatherFetcher: WeatherFetcherProtocol {

    let isThrow: Bool
    let response: WeatherResponse?

    func fetch() throws -> WeatherResponse {
        if isThrow {
            throw AppError.unknown
        } else {
            return response!
        }
    }
}
