import UIKit
import CoreLocation
import Kingfisher
import AVKit


class ViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var topScreenView: UIView!
    @IBOutlet weak var mainTemperatureLabel: UILabel!
    @IBOutlet weak var weatherDiscriptionLabel: UILabel!
    @IBOutlet weak var weatherPictureImageView: UIImageView!
    @IBOutlet weak var feelsLikeTempLabel: UILabel!
    @IBOutlet weak var precipLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var sunSetLabel: UILabel!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var additionalView: UIView!
    @IBOutlet weak var middleBackgroundImageView: UIImageView!
    @IBOutlet weak var middleScreenView: UIView!
    @IBOutlet weak var forecastTableView: UITableView!
    
    var videoPlayer: AVPlayer?
    var videoPlayerLayer: AVPlayerLayer?
    var locationManager = CLLocationManager()
    var coordinate = ""
    var city = ""
    var response: WeatherResponse?
    var model = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureModel()
        self.getLocation()
        self.getForecast()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.makeUIBeauty()
    }
    
    @IBAction func goFavoritesVC(_ sender: UIBarButtonItem) {
        guard let favoritesVC = storyboard?.instantiateViewController(withIdentifier: "FavoritesViewController") as? FavoritesViewController else { return }
        favoritesVC.delegate = self
        self.navigationController?.pushViewController(favoritesVC, animated: true)
    }
    
    private func sendCityRequest() {
        self.checkCity(city: city)
        Manager.shared.sendCity(city: city) { [weak self] in
            self?.showWeather()
        }
    }
    
    private func showWeather() {
        guard let name = Manager.shared.json?.current.condition?.text else { return }
        let videoName = Manager.shared.getCurrentVideo(definition: name)
        self.setUpVideo(name: videoName)
        model.showWeather()
        self.forecastTableView.reloadData()
    }
    

    
    private func setUpVideo(name: String) {
        let video = name
        guard let bundlePath = Bundle.main.path(forResource: video, ofType: "mp4") else { return }
        
        let url = URL(fileURLWithPath: bundlePath)
        let item = AVPlayerItem(url: url)
        
        self.videoPlayer = AVPlayer(playerItem: item)
        self.videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        self.videoPlayerLayer?.frame = self.topScreenView.bounds
        self.videoPlayerLayer?.videoGravity = .resizeAspectFill
        self.videoView.layer.addSublayer(videoPlayerLayer!)
        self.videoPlayer?.playImmediately(atRate: 0.5)
    }
    

    
    private func getLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    private func getForecast() {
        let forecast = UserDefaults.standard.value(WeatherResponse.self, forKey: "weather")
        self.response = forecast
    }
    
    private func checkCity(city: String) {
        if city.count >= 2 {
            self.city = city.replacingOccurrences(of: " ", with: "%20")
        } else {
            self.city = city
        }
    }
    
    private func makeUIBeauty() {
        let radius = middleBackgroundImageView.frame.height / 4
        let height = middleBackgroundImageView.frame.height / 10
        let position = CGSize(width: 0, height: height)
        self.middleBackgroundImageView.roundCorners(radius: radius)
        self.middleScreenView.setRadiusWithShadow(radius: radius, position: position, opacity: 0.5)
        self.additionalView.roundCorners(radius: self.additionalView.frame.height / 2)
        self.weatherView.roundCorners(radius: self.additionalView.frame.height / 2)
    }
    
    func configureModel() {
        model.cityLabel.bind { [weak self] text in
            self?.cityLabel.text = text
        }
        
        model.countryLabel.bind { [weak self] text in
            self?.countryLabel.text = text
        }
        
        model.feelsLikeTempLabel.bind { [weak self] text in
            self?.feelsLikeTempLabel.text = text
        }
        
        model.humidityLabel.bind { [weak self] text in
            self?.humidityLabel.text = text
        }
        
        model.mainTemperatureLabel.bind { [weak self] text in
            self?.mainTemperatureLabel.text = text
        }
        
        model.precipLabel.bind { [weak self] text in
            self?.precipLabel.text = text
        }
        
        model.regionLabel.bind { [weak self] text in
            self?.regionLabel.text = text
        }
        
        model.sunRiseLabel.bind { [weak self] text in
            self?.sunRiseLabel.text = text
        }
        
        model.sunSetLabel.bind { [weak self] text in
            self?.sunSetLabel.text = text
        }
        
        model.weatherDiscriptionLabel.bind { [weak self] text in
            self?.weatherDiscriptionLabel.text = text
        }
        
        model.weatherPictureImageView.bind { [weak self] image in
            self?.weatherPictureImageView = image
        }
        
        model.windSpeedLabel.bind { [weak self] text in
            self?.windSpeedLabel.text = text
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager (_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.locationManager.stopUpdatingLocation()
        self.coordinate = "\(location.latitude),\(location.longitude)"
        
        Manager.shared.sendCoordinate(coordinate: self.coordinate) { [weak self] in 
            self?.showWeather()
        }
    }
}


extension ViewController: FavoritesViewControllerDelegate  {
    func addFavoriteCity(with object: WeatherResponse?, or city: String?) {
        if let city = object?.location.name {
            self.city = city
        } else {
            self.city = city!
        }
        self.sendCityRequest()
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.forecast.forecastday.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell", for: indexPath) as? ForecastTableViewCell else {
            return UITableViewCell()
        }
        
        if let forecast = response?.forecast.forecastday[indexPath.row] {
        cell.configure(with: forecast)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 10
    }
    
    
}


