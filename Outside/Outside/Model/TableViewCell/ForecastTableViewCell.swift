import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherPictureImageView: UIImageView!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    func configure(with object: Forecast) {
        
        if let date = object.date,
           let icon = object.day?.condition?.icon?.dropFirst(2),
           let date_epoch = object.date_epoch,
           let maxtemp_c = object.day?.maxtemp_c,
           let mintemp_c = object.day?.mintemp_c {
            
            let localDate = Date(timeIntervalSince1970: date_epoch)
            let url = URL(string: "https://" + icon)
            
            dateLabel.text = date
            dayLabel.text = localDate.getDay()
            weatherPictureImageView.kf.setImage(with: url)
            maxTempLabel.text = "\(Int(maxtemp_c))°"
            minTempLabel.text = "\(Int(mintemp_c))°"
        }
    }
    
}
