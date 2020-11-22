//
//  AqiViewController.swift
//  The Dust
//
//  Created by Jun on 2020/11/18.
//

import UIKit
import CoreLocation

class AqiViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: AQI View
    @IBOutlet weak var aqiView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var aqiStatusBigLabel: UILabel!
    @IBOutlet weak var aqiStatusSmallLabel: UILabel!
    @IBOutlet weak var emojiImageView: UIImageView!
    @IBOutlet weak var pm10Label: UILabel!
    @IBOutlet weak var pm25Label: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    
    //MARK: ChartWholeView
    @IBOutlet weak var chartWholeView: UIView!
    @IBOutlet weak var graphView: AqiChartView!
    @IBOutlet weak var goDetailButton: UIButton!
    
    //MARK: Weather VIew
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var weatherAddLabel: UILabel!
    @IBOutlet weak var smallWeatherLabel: UILabel!
    @IBOutlet weak var bigWeatherLabel: UILabel!
    @IBOutlet weak var maxCelsiusLabel: UILabel!
    @IBOutlet weak var minCelsiusLabel: UILabel!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var aqiDataSet = [AqiResponseString]()
    var weatherDataSet = [WeatherResponseString]()
    static var aqiList:[Double] = []
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager = manager
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
        }
    }
    
    //위치 허용시 처리하는 방식
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined :
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse :
            self.firstSetting()
            break
        case .authorizedAlways :
            self.firstSetting()
            break
        case .restricted :
            break
        case .denied :
            break
        default:
            break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.aqiView.setViewShadow()
        self.chartWholeView.setViewShadow()
        self.graphView.setViewShadow()
        self.graphView.contentMode = .scaleAspectFit
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        self.animateEmojiImage()
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { _ in
            self.animateEmojiImage()
        })
        
        self.connectWeatherAPI()
        
    }
    
    //MARK: 위치 받아오기 에러 처리
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
                let alert = UIAlertController(title: "오류 발생", message: "위치 서비스 기능이 꺼져있음", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
            }
        } else {
            let alert = UIAlertController(title: "오류 발생", message: "위치 서비스 기능이 꺼져있음", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        //이미 허용인 경우
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.firstSetting()
        }
        
        self.weatherView.setGradientBackground(colorTop: UIColor.white, colorBottom: UIColor.skyblue)
        self.weatherView.setViewShadow()
        self.weatherView.layer.cornerRadius = 3
        
    }
    
    //MARK: find location and address
    func firstSetting() {
        self.currentLocation = locationManager.location
        self.findAddr(lat: self.currentLocation.coordinate.latitude, long: self.currentLocation.coordinate.longitude)
    }
    
    //MARK: 위도, 경도에 따른 주소 찾기
    func findAddr(lat: CLLocationDegrees, long: CLLocationDegrees) {
        let findLocation = CLLocation(latitude: lat, longitude: long)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale) { (placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                if let area: String = address.last?.name {
                    self.addressLabel.text = area
                }
                if let name:String = address.last?.locality {
                    self.connectAqiAPI(region: name)
                    self.weatherAddLabel.text = name
                }
            }
        }
    }
    
    //MARK: 더보기 페이지 이동
    @IBAction func moveDetail(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AqiDetailViewController") as! AqiDetailViewController
        
        vc.pm10Str = self.aqiDataSet[0].list![0].pm10Value ?? ""
        vc.pm25Str = self.aqiDataSet[0].list![0].pm25Value ?? ""
        vc.ozoneStr = self.aqiDataSet[0].list![0].o3Value ?? ""
        vc.coStr = self.aqiDataSet[0].list![0].coValue ?? ""
        vc.soStr = self.aqiDataSet[0].list![0].so2Value ?? ""
        vc.noStr = self.aqiDataSet[0].list![0].no2Value ?? ""
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: emoji animation
    func animateEmojiImage() {
        self.emojiImageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
            self.emojiImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
    //MARK: 미세먼지 API 연결 + 미세먼지 수치 뷰에 그리기
    func connectAqiAPI(region: String){
        let aqiURLString = AqiService.shared.makeAqiAddress(region: region)
        let aqiURL = URL(string: aqiURLString)!
        
        do {
            let responseString = try String(contentsOf: aqiURL)
            guard let data = responseString.data(using: .utf8) else { return }
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(AqiResponseString.self, from: data) {
                self.aqiDataSet = [object] as! [AqiResponseString]
                
                
                let pm10Val: String = self.aqiDataSet[0].list![0].pm10Value ?? ""
                let pm25Val: String = self.aqiDataSet[0].list![0].pm25Value ?? ""
                self.pm10Label.text = self.getPm10String(pm10: pm10Val) + " " + pm10Val + " ㎍/㎥"
                self.pm25Label.text = self.getPm25String(pm25: pm25Val) + " " + pm25Val + " ㎍/㎥"
                
                AqiChartView.playAnimations()
            }
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    }
    
    //MARK: 날씨 API 연결
    func connectWeatherAPI(){
        let weatherURLString = "https://api.openweathermap.org/data/2.5/weather?q=seoul&appid=853c909f0f8639d63344ec1b9f73c12a"
        let weatherURL = URL(string: weatherURLString)!
        
        do {
            let weatherResponse = try String(contentsOf: weatherURL)
            guard let weatherData = weatherResponse.data(using: .utf8) else { return }
            let weatherDecoder = JSONDecoder()
            if let weatherObject = try? weatherDecoder.decode(WeatherResponseString.self, from: weatherData) {
                
                self.bigWeatherLabel.text = String(format: "%.f", weatherObject.main.temp - 273.15) + " °C"
                
                self.maxCelsiusLabel.text = "최고 " + String(format: "%.f", weatherObject.main.tempMin-273.15) + " °C"
                
                self.minCelsiusLabel.text = "최저 " + String(format: "%.f", weatherObject.main.tempMax-273.15) + " °C"
                
            }
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    }
    
    
    @IBAction func clickPm10Btn(_ sender: UIButton) {
        let sb = UIStoryboard(name: "PopupStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "PopupViewController") as! PopupViewController
        vc.isPm10 = true
        vc.pm10 = self.aqiDataSet[0].list![0].pm10Value!
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func clickPm25Btn(_ sender: UIButton) {
        let sb = UIStoryboard(name: "PopupStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "PopupViewController") as! PopupViewController
        vc.isPm10 = false
        vc.pm25 = self.aqiDataSet[0].list![0].pm25Value!
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: true, completion: nil)
    }
    

    //MARK: 미세먼지 수치에 따른 기준(pm 10)
    func getPm10String(pm10: String) -> String {
        guard  let pm10Int = Int(pm10) else { return "정보없음" }
        var pm10Str: String = ""
        
        switch pm10Int {
        case let x where x <= 30:
            pm10Str = "좋음"
            self.emojiImageView.image = UIImage(named: "emoji1")
            self.aqiStatusSmallLabel.text = "쾌적한 날이에요~"
        case let x where x <= 80 :
            pm10Str = "보통"
            self.emojiImageView.image = UIImage(named: "emoji2")
            self.aqiStatusSmallLabel.text = "나쁘지 않은 날이에요."
        case let x where x <= 150 :
            pm10Str = "나쁨"
            self.emojiImageView.image = UIImage(named: "emoji3")
            self.aqiStatusSmallLabel.text = "탁한 공기, 마스크 꼭 챙기세요~"
        default:
            pm10Str = "매우 나쁨"
            self.emojiImageView.image = UIImage(named: "emoji4")
            self.aqiStatusSmallLabel.text = "밖에 나가면 죽음뿐!"
        }
        
        self.aqiStatusBigLabel.text = pm10Str
        return pm10Str
        
    }
    
    //MARK: 초미세먼지 수치에 따른 기준(pm 25)
    func getPm25String(pm25: String) ->  String {
        guard let pm25Int = Int(pm25) else { return "정보없음" }
        var pm25Str: String = ""
        
        switch pm25Int {
        case let x where x <= 30:
            pm25Str = "좋음"
        case let x where x <= 80 :
            pm25Str = "보통"
        case let x where x <= 150 :
            pm25Str = "나쁨"
        default:
            pm25Str = "매우 나쁨"
        }
        
        return pm25Str
    }
    
    
}
