import UIKit

class Manager {
    
    enum Keys: String {
        case weather = "weather"
        case favorites = "favorites"
        case forecast = "forecast"
    }
    
    static let shared = Manager()
    
    private init () {}
    
    var userDefaults = UserDefaults.standard
    var json: WeatherResponse?
    var favorites: [WeatherResponse]?
    var is_exist = false
    
    func sendCoordinate(coordinate: String, completion: @escaping ()->()) {
        
        guard let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=b4e27fe86f0345d189f131342202511&q=\(coordinate)&days=3") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data {
                do {
                    let jsonResult = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    
                    self.saveWeather(object: jsonResult)
                    self.saveCityByCordinate(object: jsonResult)
                    
                    self.json = self.loadWeather()
                    
                    DispatchQueue.main.async {
                        completion()
                    }
                    
                } catch {
                    print("Data error")
                }
            } else {
                print("error")
            }
        }
        task.resume()
    }
    
    func sendCity(city: String, completion: @escaping ()->()) {
        
        guard let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=b4e27fe86f0345d189f131342202511&q=\(city)&days=3") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data {
                do {
                    let jsonResult = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    self.saveWeather(object: jsonResult)
                    self.saveCityByName(object: jsonResult)
                    self.json = self.loadWeather()
                    
                    DispatchQueue.main.async {
                        completion()
                    }
                    
                } catch {
                    print("Data error")
                }
            } else {
                print("error")
            }
        }
        task.resume()
    }
    
    func saveWeather(object: WeatherResponse) {
        userDefaults.set(encodable: object, forKey: Keys.weather.rawValue)
    }
    
    func saveCityByCordinate(object: WeatherResponse) {
        var favorites = Manager.shared.loadFavorites()
        
        if favorites?.isEmpty == true {
            favorites?.insert(object, at: 0)
        } else {
            favorites?.removeFirst()
            favorites?.insert(object, at: 0)
        }
        
        userDefaults.set(encodable: favorites, forKey: Keys.favorites.rawValue)
    }
    
    func saveCityByName(object: WeatherResponse) {
        var favorites = self.loadFavorites()
        
        if let favorites = favorites {
            for element in favorites {
                if element.location.name == object.location.name {
                    self.is_exist = true
                }
            }
        }
        
        if self.is_exist == false {
            favorites?.append(object)
            userDefaults.set(encodable: favorites, forKey: Keys.favorites.rawValue)
        }
        
        self.is_exist = false
    }
    
    func loadWeather() -> WeatherResponse? {
        let weather = userDefaults.value(WeatherResponse.self, forKey: Keys.weather.rawValue)
        return weather
    }
    
    func loadFavorites() -> [WeatherResponse]? {
        let weatherArray = userDefaults.value([WeatherResponse].self, forKey: Keys.favorites.rawValue)
        
        if let weatherArray = weatherArray {
            return weatherArray
        } else {
            return []
        }
    }
    
    func deleteFavorite(numberOfRow: Int) {
        var favorites = Manager.shared.loadFavorites()
        
        favorites?.remove(at: numberOfRow)
        userDefaults.set(encodable: favorites, forKey: Keys.favorites.rawValue)
    }
    
    func getCurrentVideo(definition: String) -> String {
        switch definition.lowercased()  {
        case let text where text.contains("rain"):
            return "rain"
        case let text where text.contains("thunder"):
            return "thunder"
        case let text where text.contains("snow"):
            return "snow"
        case let text where text.contains("cloudy"):
            return "cloudy"
        case let text where text.contains("clear"):
            return "sunny"
        case let text where text.contains("sunny"):
            return "sunny"
        case let text where text.contains("overcast"):
            return "overcast"
        case let text where text.contains("mist"):
            return "fog"
        case let text where text.contains("fog"):
            return "fog"
        default:
            return "normal"
        }
    }
 
}
