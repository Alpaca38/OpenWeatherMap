//
//  Extension+UILabel.swift
//  OpenWeatherMap
//
//  Created by 조규연 on 6/5/24.
//

import UIKit

extension UILabel {
    func setWeatherLabel() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 8
        font = .systemFont(ofSize: 17)
    }
}
