//
//  WeatherApiService.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class WeatherApiService {
    
    private let apiURL = "https://api.openweathermap.org/data/2.5"
    private let apiKey = "appid=56151fef235e6cebb33750525932d021"
    private let units = "units=metric"
    private let exclusions = "exclude=minutely,hourly"
    private let parsingService: ParsingService
    
    init(parsingService: ParsingService) {
        self.parsingService = parsingService
    }
    
    func fetchCurrentWeather(completion: @escaping (Result<[CurrentWeather], Error>) -> Void) {
        let ids = City.allCases.map{ $0.rawValue}.map { String($0) }.joined(separator:",")
        let urlString = "\(apiURL)/group?\(apiKey)&\(exclusions)&\(units)&id=\(ids)"

        performRequest(with: urlString) { (data) in
        let parsedResponse = self.parsingService.parseCurrentWeather(data)
            
            guard let weatherResponse = parsedResponse else {
                completion(.failure())
                return
            }
            
            completion(.SUCCESSFUL(data: weatherResponse))
        }
    }
    
    func fetchHourlyWeather(for city: String, completion: @escaping (WeatherApiResponse) -> Void) {
        let urlString = "\(apiURL)/forecast?\(apiKey)&\(units)&q=\(city)"
        
        performRequest(with: urlString) { (data) in
            
            let parsedResponse = self.parsingService.parseHourlyWeather(data, city: city)
            
            guard let hourlyWeather = parsedResponse else {
                completion(.FAILED(error: "Cannot parse data correctly!"))
                return
            }
            
            completion(.SUCCESSFUL(data: hourlyWeather))
        }
    }
    
    func fetchDailyWeather(with latitude: String,_ longitude: String, completion: @escaping (WeatherApiResponse) -> Void) {
        let urlString = "\(apiURL)/onecall?\(apiKey)&\(units)&lat=\(latitude)&lon=\(longitude)&\(exclusions)"
        
        performRequest(with: urlString) { (data) in
            let parsedResponse = self.parsingService.parseDailyWeather(data)
            
            guard let dailyWeather = parsedResponse else {
                completion(.FAILED(error: "Cannot parse data correctly"))
                return
            }
            
            completion(.SUCCESSFUL(data: dailyWeather))
        }
    }
    
    func performRequest(with urlString: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching weather data: \(error)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            completion(data)
        })
        task.resume()
    }
    
}

