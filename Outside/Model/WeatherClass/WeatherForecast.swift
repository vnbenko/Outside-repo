import Foundation

class WeatherForecast: Codable {
    
    var forecastday: [Forecast]
}

class Forecast: Codable {
    
    var date: String?
    var date_epoch: Double?
    var day: ForecastDay?
    var astro: ForecastAstro?
}

class ForecastDay: Codable {
    
    var maxtemp_c: Double?
    var mintemp_c: Double?
    var daily_will_it_rain: Int?
    var condition: ForecastCondition?
}

class ForecastCondition: Codable {

    var text: String?
    var icon: String?
}


class ForecastAstro: Codable {

    var sunrise: String?
    var sunset: String?
}

