//
//  ButtonExtention.swift
//  SpeechRecognition
//
//  Created by Ekaterina Tarasova on 13.08.2021.
//

import UIKit
extension UIButton{
    func isSelectedButton() {
        self.alpha = 1
    }
    
    func isDeselectedButton() {
        self.alpha = 0.5
    }
}
