import UIKit
import Kingfisher

class ViewModel {
    
    let weatherPictureImageView = Bindable(UIImageView())
    let cityLabel = Bindable("")
    let regionLabel = Bindable("")
    let countryLabel = Bindable("")
    let weatherDiscriptionLabel = Bindable("")
    let mainTemperatureLabel = Bindable("")
    let sunRiseLabel = Bindable("")
    let sunSetLabel = Bindable("")
    let humidityLabel = Bindable("")
    let windSpeedLabel = Bindable("")
    let feelsLikeTempLabel = Bindable("")
    let precipLabel = Bindable("")
    
    func showWeather() {
        let response = Manager.shared.json
        if let name = response?.location.name,
           let region = response?.location.region,
           let country = response?.location.country,
           let text = response?.current.condition?.text,
           let icon = response?.current.condition?.icon?.dropFirst(2),
           let temp_c = response?.current.temp_c,
           let sunrise = response?.forecast.forecastday.first?.astro?.sunrise,
           let sunset = response?.forecast.forecastday.first?.astro?.sunset,
           let humidity = response?.current.humidity,
           let wind_kph = response?.current.wind_kph,
           let feelslike_c = response?.current.feelslike_c,
           let precip_mm = response?.current.precip_mm {
            
            let url = URL(string: "https://" + icon)
            self.weatherPictureImageView.value.kf.setImage(with: url)
            self.cityLabel.value = name
            self.regionLabel.value = region
            self.countryLabel.value = country
            self.weatherDiscriptionLabel.value = text
            
            self.mainTemperatureLabel.value = "\(Int(temp_c))°"
            self.sunRiseLabel.value = sunrise
            self.sunSetLabel.value = sunset
            self.humidityLabel.value = "\(humidity)%"
            self.windSpeedLabel.value = "\(wind_kph) km/h"
            self.feelsLikeTempLabel.value = "Feels like \(Int(feelslike_c))°"
            self.precipLabel.value = "\(precip_mm) mm"
            
            
        }
    }
}
