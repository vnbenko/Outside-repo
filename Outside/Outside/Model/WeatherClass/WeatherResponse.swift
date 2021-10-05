import Foundation

class WeatherResponse: Codable {
    
    var location: WeatherLocation
    var current: WeatherCurrent
    var forecast: WeatherForecast
    
}
    
