//
//  TableViewCell.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    let containerView = UIView()
    let weatherIcon = UIImageView()
    let cityLabel = UILabel()
    let currentTempLabel = UILabel()
    let minTempLabel = UILabel()
    let maxTempLabel = UILabel()
    
    var weather: WeatherData? {
        didSet {
            guard let weatherData = weather else { return }
            weatherIcon.image = UIImage(systemName: weatherData.icon)
            cityLabel.text = weatherData.city
            currentTempLabel.text = "\(weatherData.parameters.currentTemperature)°"
            minTempLabel.text = "\(weatherData.parameters.minTemperature)°"
            maxTempLabel.text = "\(weatherData.parameters.maxTemperature)° /"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    func setupUI() {
        contentView.backgroundColor = .systemBlue
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        
        UISetup.setImageView(weatherIcon)
        UISetup.setLabel(cityLabel, size: 30, textAlignment: .left)
        UISetup.setLabel(currentTempLabel, size: 40, textAlignment: .right)
        UISetup.setLabel(maxTempLabel, size: 15, textAlignment: .right)
        UISetup.setLabel(minTempLabel, size: 15, textAlignment: .left)
        cityLabel.numberOfLines = 0
        minTempLabel.textColor =  .systemGray4

        contentView.addSubview(containerView)
        contentView.addSubview(weatherIcon)
        contentView.addSubview(cityLabel)
        containerView.addSubview(currentTempLabel)
        containerView.addSubview(minTempLabel)
        containerView.addSubview(maxTempLabel)
    }
    
    func setupConstraints() {
        weatherIcon.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        weatherIcon.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant: 15).isActive = true
        weatherIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        weatherIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        cityLabel.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        cityLabel.leadingAnchor.constraint(equalTo:self.weatherIcon.trailingAnchor, constant: 20).isActive = true
        cityLabel.trailingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: -10).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor, constant: -10).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant: -15).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        currentTempLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 30).isActive = true
        currentTempLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        currentTempLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
    
        maxTempLabel.topAnchor.constraint(equalTo: self.currentTempLabel.bottomAnchor, constant: 5).isActive = true
        maxTempLabel.bottomAnchor.constraint(equalTo:self.containerView.bottomAnchor, constant: -5).isActive = true
        maxTempLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        
        minTempLabel.topAnchor.constraint(equalTo: self.currentTempLabel.bottomAnchor, constant: 5).isActive = true
        minTempLabel.bottomAnchor.constraint(equalTo:self.containerView.bottomAnchor, constant: -5).isActive = true
        minTempLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        minTempLabel.leadingAnchor.constraint(equalTo: self.maxTempLabel.trailingAnchor, constant: 2).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}