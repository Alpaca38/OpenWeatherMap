//
//  WeatherData.swift
//  OpenWeatherMap
//
//  Created by 조규연 on 6/5/24.
//

import Foundation

struct WeatherData: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    
    var tempString: String {
        return "지금은 \(Int(main.temp - 273.15))°C 에요"
    }
    
    var humidityString: String {
        return "\(main.humidity)% 만큼 습해요"
    }
    
    var windSpeedString: String {
        return "\(wind.speed)m/s의 바람이 불어요"
    }
    
    var iconURL: URL {
        let url = URL(string: "https://openweathermap.org/img/wn/\(weather.first!.icon)@2x.png")!
        return url
    }
}

struct Weather: Codable {
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
}
