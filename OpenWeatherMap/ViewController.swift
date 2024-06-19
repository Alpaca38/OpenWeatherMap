//
//  ViewController.swift
//  OpenWeatherMap
//
//  Created by 조규연 on 6/5/24.
//

import UIKit
import CoreLocation
import MapKit
import SnapKit
import Alamofire
import Kingfisher

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
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
    lazy var mapView = {
        let view = MKMapView()
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
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
        
        mapView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(200)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .systemOrange
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .white
        dateLabel.text = Date().formattedDate()
        
        locationLabel.font = .systemFont(ofSize: 24)
        locationLabel.textColor = .white
        
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
    
    func callRequest(coordinate: CLLocationCoordinate2D) {
        let url = "\(APIURL.weatherAPIURL)lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(APIKey.weatherAPIKey)"
        AF.request(url).responseDecodable(of: WeatherData.self) { response in
            switch response.result {
            case .success(let value):
                self.tempLabel.text = value.tempString
                self.humidityLabel.text = value.humidityString
                self.windLabel.text = value.windSpeedString
                self.weatherImageView.kf.setImage(with: value.iconURL)
                self.locationLabel.text = "내 위치"
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController {
    func checkDeviceLocationAuthorization() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.currentLocationAuthorization()
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "아이폰 위치 서비스를 활성화해야합니다.", message: "설정 - 개인정보 보호 및 보안 - 위치 서비스를 활성화 해주세요. 설정으로 이동하시겠습니까?")
                }
            }
        }
    }
    
    func currentLocationAuthorization() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            DispatchQueue.main.async {
                self.showAlert(title: "앱의 위치 권한을 설정해주세요.", message: "설정 - 개인정보 보호 및 보안 - 위치 서비스에서 앱의 위치 권한을 설정해주세요. 설정으로 이동하시겠습니까?")
            }
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print(status)
        }
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        mapView.addAnnotation(annotation)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            setRegionAndAnnotation(center: coordinate)
            callRequest(coordinate: coordinate)
        }
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthorization()
    }
}
