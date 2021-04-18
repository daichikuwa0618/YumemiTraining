//
//  DateFormatterUtil.swift
//  YumemiTraining
//
//  Created by Daichi Hayashi on 2021/04/18.
//

import Foundation

protocol DateFormatterUtilProtocol {
    /// ISO8601 形式フォーマッティングの Option を追加設定する
    func setOptions(with options: [ISO8601DateFormatter.Options])
    /// ISO8601 形式フォーマッティングの Option を削除設定する
    func removeOptions(with options: [ISO8601DateFormatter.Options])
    /// Date から ISO8601 形式の String を生成する
    func createString(from date: Date) -> String
    /// ISO8601 形式の String から Date を生成する
    /// - Parameter string: 変換元の ISO8601 形式文字列
    /// - returns: Date (入力が不正な形式の場合は nil を返す)
    func createDate(from string: String) -> Date?
}

class DateFormatterUtil: DateFormatterUtilProtocol {

    // MARK: - Private property

    private let formatter: ISO8601DateFormatter = ISO8601DateFormatter()

    // MARK: - DateFormatterUtilProtocol

    func setOptions(with options: [ISO8601DateFormatter.Options]) {
        options.forEach { option in
            formatter.formatOptions.insert(option)
        }
    }

    func removeOptions(with options: [ISO8601DateFormatter.Options]) {
        options.forEach { option in
            formatter.formatOptions.remove(option)
        }
    }

    func createString(from date: Date) -> String {
        formatter.string(from: date)
    }

    func createDate(from string: String) -> Date? {
        formatter.date(from: string)
    }
}
