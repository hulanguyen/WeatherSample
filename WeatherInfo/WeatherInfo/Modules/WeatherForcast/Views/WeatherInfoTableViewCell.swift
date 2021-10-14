//
//  WeatherInfoTableViewCell.swift
//  WeatherInfo
//
//  Created by Lam Nguyen Huu (VN) on 11/10/2021.
//

import UIKit
import SDWebImage

class WeatherInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: SDAnimatedImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(data: WeatherData) {
        dateLabel.text = data.dt.getDateWithFormat(.DDddMMyyyy)
        temperatureLabel.text =  String(format: "%0.2f °C", data.temp.average)
        humidityLabel.text = "\(data.humidity)"
        pressureLabel.text = "\(data.pressure)"
        descriptionLabel.text = data.weather.first?.description
//        iconLabel.text = "\(data.weather.first?.icon)"
        guard let icon = data.weather.first?.icon, let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else {return}
        iconImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        iconImageView?.sd_setImage(with: url, completed: nil)
    }
    
}
