import UIKit
import Foundation

extension UIView{
    func setGradient(color1:UIColor,color2:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}

class ViewController: UIViewController {
    var weather: Weather?
    var main: Main?
    var name: String?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeatherInfo().getWeather { result in
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    self.weather = weatherResponse.weather.first
                    self.main = weatherResponse.main
                    self.name = weatherResponse.name
                    self.setWeatherUI()
                }
            case .failure(_):
                print("error")
            }
        }
        
//        WeatherInfo().getLocation(lat: coord?.lat, lon: coord?.lon) { result in
//            switch result {
//            case .success(let location):
//                DispatchQueue.main.async {
//                    self.coord = location.c
//                }
//            }
//            
//        }
//        
    backgroundView.setGradient(color1: UIColor(red: 0, green: 0.4706, blue: 0.9765, alpha: 1), color2: UIColor.white)
    }
    
    private func setWeatherUI() {
        switch weather!.main {
        case "Rain":
            weatherImg.image = UIImage(named: "rainy")
        case "Clear":
            weatherImg.image = UIImage(named: "sunset")
        case "Cloudy":
            weatherImg.image = UIImage(named: "cloudy")
        default:
            print(weather!.main)
        }

        tempLabel.text = "\(Int(round(main!.temp))) º"
        maxTempLabel.text = "\(Int(round(main!.temp_max))) º"
        minTempLabel.text = "\(Int(round(main!.temp_min))) º"
    }
    
}

