import Foundation

struct WeatherResponse: Decodable {
    let weather: [Weather]
    let main: Main
    let name: String
}

struct Main: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
}

enum NetworkError: Error {
    case badUrl
    case noData
    case decodingError
}

class WeatherInfo {
    private var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "PropertyList", ofType: "plist") else {
                fatalError("Couldn't find file 'PropertyList.plist'.")
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "WEATHER_API_KEY") as? String else {
                fatalError("Couldn't find key 'WEATHER_API_KEY' in 'PropertyList.plist'.")
            }
            return value
        }
    }

    func getWeather(completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=seoul&appid=\(apiKey)&units=metric")
        guard let url = url else {
            return completion(.failure(.badUrl))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)

            if let weatherResponse = weatherResponse {
                print(weatherResponse)
                completion(.success(weatherResponse))
            } else {
                completion(.failure(.decodingError))
            }
        }.resume()
    }

}
