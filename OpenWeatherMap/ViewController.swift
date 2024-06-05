//
//  ViewController.swift
//  OpenWeatherMap
//
//  Created by 조규연 on 6/5/24.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher

class ViewController: UIViewController {
    
    let dateLabel = UILabel()
    let locationLabel = UILabel()
    let tempLabel = CustomLabel()
    let humidityLabel = CustomLabel()
    let windLabel = CustomLabel()
    let weatherImageView = UIImageView()
    let happyDayLabel = CustomLabel()
    lazy var stackView = {
        let view = UIStackView(arrangedSubviews: [dateLabel, locationLabel, tempLabel, humidityLabel, windLabel, weatherImageView, happyDayLabel])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .leading
        
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callRequest()
        configureLayout()
        configureUI()
    }
    
    func configureLayout() {
        stackView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalToSuperview().multipliedBy(0.55)
        }
        
        tempLabel.snp.makeConstraints {
            $0.height.equalTo(45)
        }
        
        humidityLabel.snp.makeConstraints {
            $0.height.equalTo(45)
        }
        
        windLabel.snp.makeConstraints {
            $0.height.equalTo(45)
        }
        
        weatherImageView.snp.makeConstraints {
            $0.width.equalTo(220)
            $0.height.equalTo(150)
        }
        
        happyDayLabel.snp.makeConstraints {
            $0.height.equalTo(45)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .systemOrange
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .white
        dateLabel.text = Date().formattedDate()
        
        locationLabel.font = .systemFont(ofSize: 24)
        locationLabel.textColor = .white
        locationLabel.text = "서울"
        
        tempLabel.setWeatherLabel()
        humidityLabel.setWeatherLabel()
        windLabel.setWeatherLabel()
        happyDayLabel.setWeatherLabel()
        happyDayLabel.text = "오늘도 행복한 하루 보내세요"
        
        weatherImageView.backgroundColor = .white
        weatherImageView.clipsToBounds = true
        weatherImageView.layer.cornerRadius = 8
        weatherImageView.contentMode = .scaleAspectFit
    }
    
    func callRequest() {
        let url = "\(APIURL.weatherAPIURL)q=Seoul&appid=\(APIKey.weatherAPIKey)"
        AF.request(url).responseDecodable(of: WeatherData.self) { response in
            switch response.result {
            case .success(let value):
                self.tempLabel.text = value.tempString
                self.humidityLabel.text = value.humidityString
                self.windLabel.text = value.windSpeedString
                self.weatherImageView.kf.setImage(with: value.iconURL)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

