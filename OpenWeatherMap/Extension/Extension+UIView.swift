//
//  Extension+UIView.swift
//  OpenWeatherMap
//
//  Created by 조규연 on 6/5/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
