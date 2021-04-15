//
//  WeatherViewState.swift
//  YumemiTraining
//
//  Created by Daichi Hayashi on 2021/04/13.
//

import Foundation
import UIKit

struct WeatherViewState {
    let weather: Weather
    let image: UIImage
    let color: UIColor

    init(weather: Weather) {
        self.weather = weather

        switch weather {
        case .sunny:
            self.image = UIImage(named: "sun")!
            self.color = UIColor(named: "sun")!

        case .rainy:
            self.image = UIImage(named: "umbrella")!
            self.color = UIColor(named: "umbrella")!

        case .cloudy:
            self.image = UIImage(named: "cloud")!
            self.color = UIColor(named: "cloud")!
        }
    }
}
