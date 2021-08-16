//
//  ColorExtention.swift
//  SpeechRecognition
//
//  Created by Ekaterina Tarasova on 13.08.2021.
//

import UIKit

extension ViewController{
    func gradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemIndigo.cgColor,
            UIColor.darkGray.cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.shouldRasterize = true
        backgroundView.layer.addSublayer(gradientLayer)
    }
}
