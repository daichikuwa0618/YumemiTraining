//
//  WeatherPostObject.swift
//  YumemiTraining
//
//  Created by Daichi Hayashi on 2021/04/18.
//

import Foundation

struct WeatherPostObject: Encodable {
    let area: String
    let dateString: String

    enum CodingKeys: String, CodingKey {
        case area
        case dateString = "date"
    }
}
