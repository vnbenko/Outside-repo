import Foundation

class WeatherCurrent: Codable {

    var temp_c: Double?
    var is_day: Int?
    var wind_kph: Double?
    var precip_mm: Double?
    var humidity: Int?
    var feelslike_c: Double?
    var condition: WeatherCondition?
    
}

