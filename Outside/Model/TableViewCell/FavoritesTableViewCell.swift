import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    func configure(with object: WeatherResponse) {
        if let name = object.location.name,
           let temp_c = object.current.temp_c,
           let localtime = object.location.localtime?.dropFirst(11) {
            
            self.cityLabel.text = name
            self.temperatureLabel.text = "\(Int(temp_c))°"
            self.timeLabel.text = "\(localtime)"
        }
    }
    
}

