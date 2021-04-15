//
//  ErrorAlert.swift
//  YumemiTraining
//
//  Created by Daichi Hayashi on 2021/04/16.
//

import Foundation
import UIKit

// Enum as a namespace
enum ErrorAlert {
    /// 閉じる 1 ボタンのアラートを生成
    static func createCloseAlert(title: String, message: String) -> UIAlertController {
        let alert: UIAlertController = UIAlertController(title: title,
                                                         message: message,
                                                         preferredStyle: .alert)
        let closeAction: UIAlertAction = UIAlertAction(title: "閉じる", style: .default)
        alert.addAction(closeAction)

        return alert
    }
}
