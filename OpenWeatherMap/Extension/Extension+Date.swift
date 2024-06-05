//
//  Extension+Date.swift
//  OpenWeatherMap
//
//  Created by 조규연 on 6/5/24.
//

import Foundation

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일 HH시 mm분"
        return formatter.string(from: self)
    }
}
