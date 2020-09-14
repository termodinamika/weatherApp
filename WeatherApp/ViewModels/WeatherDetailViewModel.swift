//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherDetailViewModel {
    
    private let locationService: LocationService
    private let coordinator: Coordinator
    private var dataRepository: DataRepository
    var currentWeather: CurrentWeather
    var weeklyWeather: BehaviorRelay<WeeklyWeather>
    let disposeBag = DisposeBag()
    
    var date: String {
        Utils.getFormattedDate()
    }
    
    var time: String {
        Utils.getFormattedTime()
    }
    
    init(appDependencies: AppDependencies, currentWeather: CurrentWeather, coordinator: Coordinator) {
        self.currentWeather = currentWeather
        self.coordinator = coordinator
        self.locationService = appDependencies.locationService
        self.dataRepository = appDependencies.dataRepository
        self.weeklyWeather = BehaviorRelay(value: WeeklyWeather(city: currentWeather.city, dailyWeatherList: [], hourlyWeatherList: []))
        
        locationService.getLocationCoordinates(location: currentWeather.city)
        getWeeklyWeather()
    }
    
    func getWeeklyWeather() {
        dataRepository.getWeeklyWeather(latitude: locationService.coordinates.value.latitude,
                                        longitude: locationService.coordinates.value.longitude)
            .subscribe(
                onNext: { [weak self] (result) in
                    guard let self = self else { return }
                    
                    if case let .success(weeklyForecastEntity) = result {
                        let hourlyWeatherList = weeklyForecastEntity.hourlyWeather.map { HourlyWeather(from: $0 as! HourlyWeatherEntity) }
                        let dailyWeatherList = weeklyForecastEntity.dailyWeather.map { DailyWeather(from: $0 as! DailyWeatherEntity ) }
                        var newWeeklyWeather = WeeklyWeather(city: self.currentWeather.city, dailyWeatherList: dailyWeatherList, hourlyWeatherList: hourlyWeatherList)
                        
                        newWeeklyWeather.dailyWeatherList.sort { $0.dateTime < $1.dateTime }
                        newWeeklyWeather.hourlyWeatherList.sort { $0.dateTime < $1.dateTime }
                        self.weeklyWeather.accept(newWeeklyWeather)
                    }
            }).disposed(by: self.disposeBag)
    }
    
}

