//
//  FirstViewController.swift
//  YumemiTraining
//
//  Created by Daichi Hayashi on 2021/04/19.
//

import UIKit

class FirstViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let vc = WeatherViewController()
        vc.modalPresentationStyle = .fullScreen

        present(vc, animated: true)
    }
}
